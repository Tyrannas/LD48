extends CanvasLayer

signal start_game

func _ready():
    $Start.connect("pressed", self, "_on_Button_pressed")
    $ArrowLeft.play()
    $ArrowRight.play()
    $Sailors.play()
    $Keys_left.play()
    $Keys_right.play()
    
    $Left_Q.play()
    $Left_A.play()
    $Right_D.play()
    
    $AnimationPlayer.play("Player")
    
    
func _on_Button_pressed():
    get_tree().change_scene("res://Main.tscn")



