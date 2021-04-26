extends Node2D

signal biome_signal

# When adding the breath inputs in the GUI, there is an offset of ~23 between the position and the 
# Could not find where it came from (not from margin apparently)
var RANDOM_X_OFFSET = 23
var BACKGROUND_WIDTH = 680

var background_size
var biome_index = 0

var fade_out_duration = 3.0
var fade_in_duration = 1.5
var fade_type = 1 # TRANS_SINE
onready var current_music_player = get_node("Player/Music")

var BiomeTransition = preload("res://BiomeTransition.tscn")
var Coin = preload("res://Gold.tscn")
var Algue = preload('res://assets/prefabs/algue/algue.tscn')
var Caillou = preload('res://assets/prefabs/caillou/caillou.tscn')
var Kraken = preload('res://assets/prefabs/kraken/kraken.tscn')

var rng = RandomNumberGenerator.new()
    
var biome_infos = [
    {
        'depth': 0,
        'inputs': ['ui_left', 'ui_right'],
        'music': "music.ogg",
        'bpm': 60.0,
        'sprites': {"object": Algue, "number": 2},
    },
    {
        'depth': 100,
        'inputs': ['ui_up', 'ui_up', 'ui_right', 'ui_left'],
        'music': "pom_pom_pom.wav",
        'bpm': 120.0,
        'sprites': {"object": Caillou, "number": 1},
    },
    {
        'depth': 300,
        'inputs': ['ui_left', 'ui_right', 'ui_up', 'ui_down', 'ui_left', 'ui_right'],
        'music': "tibidibidi.wav",
        'bpm': 220.0,
        'sprites': {"object": Kraken, "number": 2},
    },
]

func get_biome_inputs(index):
    return biome_infos[index]['inputs']

func get_biome_depth(index):
    return biome_infos[index]['depth']
    
func get_biome_bpm(index):
    return biome_infos[index]['bpm']
    
func get_biome_sprites(index):
    return biome_infos[index]['sprites']
    
func instantiate_biome_delimiters():
    # we skip the first biome
    for biome_i in len(biome_infos):
        if biome_i == 0:
            continue
        var biome_depth = self.get_biome_depth(biome_i) * 10

        var biome_transition = BiomeTransition.instance()
        var transition_sprite = biome_transition.get_node('Sprite')
        var transition_collision = biome_transition.get_node('CollisionShape2D')
        biome_transition.connect('body_entered', self, '_update_biome')  
        transition_sprite.position.y = biome_depth
        transition_collision.position.y = biome_depth
        add_child(biome_transition)
        
        var inputs = self.get_biome_inputs(biome_i)
        var breah_input_node = $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/ArrowsContainer/MarginContainer/BreathInput
        for input_i in len(inputs):
            var key_sprite = breah_input_node.get_key_sprites(inputs[input_i], 1, len(inputs), input_i)
            key_sprite.position.x += RANDOM_X_OFFSET
            key_sprite.position.y = biome_depth
            add_child(key_sprite)

func populate_biomes():
    rng.randomize()
    # start spawning zone
    var start = 10
    for i in len(biome_infos):
        var end = get_biome_depth(i + 1) * 10 if i < len(biome_infos) - 1 else background_size.y
        print("spawning for biome " + str(i) +  "from " + str(start) + "to " + str(end))
        # on spawn un nombre aléatoire de trucs à spawn
        # pour chacun de ces trucs on pick un y aléatoire entre start et biome depth
        # on pick un côté random (gauche ou droite)
        # on créé l'instance, on l'add en child et on set la position
        # todo: voir pour le offset des cailloux
        var spawned = rng.randi_range(5, 10) * get_biome_sprites(i)["number"]
        for j in spawned:
            var y = rng.randf_range(start, end)
            var flipped = rng.randf_range(0,1)
            var instance = get_biome_sprites(i)["object"].instance()
            add_child(instance)
            instance.position = Vector2(-10, y)
            if flipped > 0.5:
                instance.position.x = BACKGROUND_WIDTH
                instance.scale.x = -instance.scale.x
        start = end
        
        
func spaw_coins():
    rng.randomize()
    for i in range(50, background_size.y, 150):
        var coin = Coin.instance()
        coin.connect('coin_collected', $Player/Camera2D/CanvasLayer/GUI/, "_update_score")
        add_child(coin)
        coin.position = Vector2(rng.randf_range(20, background_size.x - 20), i)
    
func _ready():
    var GUI = $Player/Camera2D/CanvasLayer/GUI/
    var Oxygen = $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/HBoxContainer/ItemsOxygen/Oxygen/Oxygen
    $Rythm.connect("keys_pressed_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/ArrowsContainer/MarginContainer/BreathInput,
                   "_display_keys_to_press")
    $Rythm.connect("oxygen_signal", Oxygen, "_update_oxygen")
    self.connect("biome_signal", $Rythm, "_update_biome_inputs")
    $Player/FadeOut.connect('tween_completed', self, '_stop_music')  
    
    Oxygen.connect("combo", GUI, "_update_combo_multiplier")
    $Rythm.connect("combo", GUI, "_update_combo_multiplier")
    
        
    # Gestion de la fin de partie
    Oxygen.connect("game_over", self, "_game_over")
    $Player.connect("end_game", self, "_game_over")
    
    background_size = $TextureRect.texture.get_size()
    $Player/Camera2D.limit_bottom = background_size.y
    
    $Player.GRAVITY = 0.0
    self.instantiate_biome_delimiters()
    self.populate_biomes()
    self.spaw_coins()
    
    if Global.is_retry == true : 
        $StartTimer.start(1)

func fade_out(stream_player):
    var tween_out = $Player/FadeOut
    # tween music volume down to 0
    tween_out.interpolate_property(stream_player, "volume_db", 0, -80, fade_out_duration, fade_type, Tween.EASE_IN, 0)
    tween_out.start()

func fade_in():
    var audio_file = "res://assets/music/" + biome_infos[biome_index]['music']
    if File.new().file_exists(audio_file):
        var new_music_player = AudioStreamPlayer.new()
        var sfx = load(audio_file)
        new_music_player.set_stream(sfx)
        new_music_player.volume_db = -80
        add_child_below_node($Player, new_music_player)
        new_music_player.play()
        var tween_in = $Player/FadeIn
         # tween music volume back to 0
        tween_in.interpolate_property(new_music_player, "volume_db", -80, 0, fade_in_duration, fade_type, Tween.EASE_OUT, 0)
        tween_in.start()
        current_music_player = new_music_player
       
func _stop_music(object, _key):
    # stop the music -- otherwise it continues to run at silent volume
    object.stop()

func _update_biome(_body):
    biome_index += 1
    self.fade_out(current_music_player)
    self.fade_in()
    emit_signal("biome_signal", self.get_biome_inputs(biome_index), self.get_biome_bpm(biome_index))

func _process(_delta):    
    if $ReadyText.visible:
        # Affichage du temps restant avant de démarrer le jeu
        $ReadyText.text = "Ready ? " + str(int($StartTimer.time_left))

func _on_StartTimer_timeout():
    new_game()

func new_game():
    Global.score = 0
    $ReadyText.visible = false
    emit_signal("biome_signal", self.get_biome_inputs(biome_index), self.get_biome_bpm(biome_index))
    $Player.GRAVITY = 3000.0
    $Player.position = Vector2(340.106,176.227)
    $Player.visible = true
    $Plouf.play()
    
func _game_over():
    $Player.GRAVITY = 0.0
    get_tree().change_scene("res://GameOver.tscn")
