extends Node2D

signal biome_change

var background_size
var biome_index = 0

#Pour chaque biome : 
#- clef : profondeur à laquelle commence le biome
#- valeur : touches à saisir séquentiellement pour respirer
var biome_inputs = {
    0: ['ui_left', 'ui_right'],
    50: ['ui_left', 'ui_up', 'ui_right', 'ui_down'],
}

# Called when the node enters the scene tree for the first time.
func _ready():
    $Rythm.connect("keys_pressed_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/HBoxContainer/ArrowsContainer/MarginContainer/BreathInput,
                   "_display_keys_to_press")
    $Rythm.connect("oxygen_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/HBoxContainer/ItemsOxygen/Oxygen/Oxygen, 
                   "_update_oxygen")
    self.connect("biome_change", $Rythm, "_update_biome_inputs")
    emit_signal("biome_change", biome_inputs[biome_index])
    
    """
        TO DO : A retirer si on instancie les pièces de manière auto
    """
    get_tree().call_group("Gold", "connect", "coin_collected", 
        $Player/Camera2D/CanvasLayer/GUI, "_update_score")
    
    background_size = $TextureRect.texture.get_size()
    $Player/Camera2D.limit_bottom = background_size.y

func _process(delta):
    # avoid crashes in the last biome
    if biome_inputs.get(biome_index + 1):
        if $Player.position.y > biome_inputs[biome_index + 1]:
            biome_index += 1
            emit_signal("biome_change", biome_inputs[biome_index])
            
    
