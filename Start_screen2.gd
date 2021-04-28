extends CanvasLayer

func _ready():
    $Normal.connect("pressed", self, "_on_Button_pressed", ["normal"])
    $Hard.connect("pressed", self, "_on_Button_pressed", ["hard"])
    $ArrowLeft.play()
    $ArrowRight.play()
    $Sailors.play()
    $Keys_left.play()
    $Keys_right.play()
    
    
func _on_Button_pressed(mode):
    Global.MODE = mode
    get_tree().change_scene("res://Main.tscn")



