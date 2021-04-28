extends CanvasLayer


func _ready():
    $Next.connect("pressed", self, "_on_Button_pressed")
    
    $PlayerMenu/Left_Q.play()
    $PlayerMenu/Left_A.play()
    $PlayerMenu/Right_D.play()
    
    $AnimationPlayer.play("Player")
    
    
func _on_Button_pressed():
    get_tree().change_scene("res://Start_screen2.tscn")
