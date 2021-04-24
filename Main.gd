extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    $Rythm.connect("keys_pressed_signal", $GUI, "_display_keys_to_press")
    $Rythm.connect("oxygen_signal", 
                   $GUI/HBoxContainer/ItemsOxygen/Oxygen/Oxygen, 
                   "_update_oxygen")
    background_size = $TextureRect.texture.get_size()
    
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
