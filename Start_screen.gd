extends CanvasLayer

signal start_game

func _ready():
    $Start.connect("pressed", self, "_on_Button_pressed")
    
func _on_Button_pressed():
    get_tree().change_scene("res://Main.tscn")
