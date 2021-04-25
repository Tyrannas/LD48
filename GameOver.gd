extends CanvasLayer

func _ready():
    if Global.is_dead == true:
        $GameOver.visible = true
        $Text.text = "Game over"
    $Score.text = "Score : " + str(Global.score)



func _on_Retry_pressed():
    Global.is_retry = true
    get_tree().change_scene("res://Main.tscn")
