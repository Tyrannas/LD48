extends Node2D

var background_size

# Called when the node enters the scene tree for the first time.
func _ready():
    $Rythm.connect("keys_pressed_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/HBoxContainer/ArrowsContainer/MarginContainer/BreathInput,
                   "_display_keys_to_press")
    $Rythm.connect("oxygen_signal", 
                   $Player/Camera2D/CanvasLayer/GUI/HBoxContainer/ItemsOxygen/Oxygen/Oxygen, 
                   "_update_oxygen")
    
    """
        TO DO : A retirer si on instancie les pièces de manière auto
    """
    get_tree().call_group("Gold", "connect", "coin_collected", 
        $Player/Camera2D/CanvasLayer/GUI, "_update_score")
    
    background_size = $TextureRect.texture.get_size()
    $Player/Camera2D.limit_bottom = background_size.y
