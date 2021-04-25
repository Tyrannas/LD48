extends Node2D

signal biome_change

var background_size
var biome_index = 0


#Pour chaque biome : 
#- clef : profondeur à laquelle commence le biome
#- valeur : touches à saisir séquentiellement pour respirer
var biome_inputs = [
    {0: ['ui_left', 'ui_right', 'ui_up', 'ui_up']},
    {50: ['ui_left', 'ui_up', 'ui_right', 'ui_down']},
    {250: ['ui_up', 'ui_up', 'ui_up', 'ui_up']}
]

func get_biome_inputs(index):
    return biome_inputs[index].values()[0]

func get_biome_depth(index):
    return biome_inputs[index].keys()[0]

func instantiate_biome_delimiters():
    var separation_picture = load("res://assets/lifebar_bg.png")
    var breah_input_node = $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/ArrowsContainer/MarginContainer/BreathInput
    # we skip the first biome
    for biome_i in len(biome_inputs):
        if biome_i == 0:
            continue
        var depth = self.get_biome_depth(biome_i) * 10
        var inputs = self.get_biome_inputs(biome_i)
        var separation_sprite = Sprite.new()
        separation_sprite.set_texture(separation_picture)
        separation_sprite.position = Vector2(0, depth)
        print("Initiate biome : " + str(separation_sprite.position))
        add_child(separation_sprite)
        for input_i in len(inputs):
            var key_sprite = breah_input_node.get_key_sprites(inputs[input_i], 0, len(inputs), input_i)
            key_sprite.position.y = depth
            add_child(key_sprite)
            print("Initiate key sprite : " + str(key_sprite.position))
            print("Initiate key Global sprites : " + str(key_sprite.global_position))

func _ready():
    $Rythm.connect("keys_pressed_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/ArrowsContainer/MarginContainer/BreathInput,
                   "_display_keys_to_press")
    $Rythm.connect("oxygen_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/HBoxContainer/ItemsOxygen/Oxygen/Oxygen, 
                   "_update_oxygen")
    self.connect("biome_change", $Rythm, "_update_biome_inputs")
    
    """
        TO DO : A retirer si on instancie les pièces de manière auto
    """
    get_tree().call_group("Gold", "connect", "coin_collected", 
        $Player/Camera2D/CanvasLayer/GUI, "_update_score")
        
    # Gestion de la fin de partie
    $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/HBoxContainer/ItemsOxygen/Oxygen/Oxygen.connect("game_over",self, "_game_over")
    $Player.connect("end_game", self, "_game_over")
    
    background_size = $TextureRect.texture.get_size()
    $Player/Camera2D.limit_bottom = background_size.y
    
    $Player.GRAVITY = 0.0
    self.instantiate_biome_delimiters()
    
    if Global.is_retry == true : 
        $StartTimer.start(1)
    
    # Pour que l'on entende bien la musique partout
    $Music.position = $Player.position



func _process(delta):
    # avoid crashes in the last biome
    if biome_index + 1 < biome_inputs.size():
        var biome_depth = self.get_biome_depth(biome_index + 1)
        if $Player.depth > biome_depth:
            biome_index += 1
            emit_signal("biome_change", self.get_biome_inputs(biome_index))
            
    # Affichage du temps restant avant de démarrer le jeu
    $ReadyText.text = "Ready ? " + str(int($StartTimer.time_left))


func _on_StartTimer_timeout():
    new_game()

func new_game():
    Global.score = 0
    $ReadyText.visible = false
    emit_signal("biome_change", self.get_biome_inputs(biome_index))
    $Player.GRAVITY = 3000.0
    $Player.position = Vector2(340.106,176.227)
    $Player.visible = true
    
func _game_over():
    $Player.GRAVITY = 0.0
    get_tree().change_scene("res://GameOver.tscn")
