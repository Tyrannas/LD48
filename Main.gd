extends Node2D

signal biome_change

var background_size
var biome_index = 0


#Pour chaque biome : 
#- clef : profondeur à laquelle commence le biome
#- valeur : touches à saisir séquentiellement pour respirer
var biome_inputs = [
    {0: ['ui_left', 'ui_right', 'ui_up']},
    {130: ['ui_left', 'ui_up', 'ui_right', 'ui_down']},
    {250: ['ui_up', 'ui_up', 'ui_up', 'ui_up']}
]

func get_inputs_from_depth():
    return biome_inputs[biome_index].values()[0]

# Called when the node enters the scene tree for the first time.
func _ready():
    $Rythm.connect("keys_pressed_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/ArrowsContainer/MarginContainer/BreathInput,
                   "_display_keys_to_press")
    $Rythm.connect("oxygen_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/VBoxContainer/HBoxContainer/ItemsOxygen/Oxygen/Oxygen, 
                   "_update_oxygen")
    self.connect("biome_change", $Rythm, "_update_biome_inputs")
    emit_signal("biome_change", self.get_inputs_from_depth())
    
    """
        TO DO : A retirer si on instancie les pièces de manière auto
    """
    get_tree().call_group("Gold", "connect", "coin_collected", 
        $Player/Camera2D/CanvasLayer/GUI, "_update_score")
    
    background_size = $TextureRect.texture.get_size()
    $Player/Camera2D.limit_bottom = background_size.y

func _process(delta):
    # avoid crashes in the last biome
    var x = biome_inputs.size()
    if biome_index + 1 < biome_inputs.size():
        var depth = $Player.depth
        var biome_depth = biome_inputs[biome_index + 1].keys()[0]
        if $Player.depth > biome_depth:
            biome_index += 1
            emit_signal("biome_change", self.get_inputs_from_depth())
            

