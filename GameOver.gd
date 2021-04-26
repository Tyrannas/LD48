extends CanvasLayer

func _ready():
    if Global.is_dead == true:
        $GameOver.visible = true
        $Text.text = "Game over"
    else :
        $GameEnd.visible = true
        $Text.text = "Hurray !"
    $Score.text = "Score : " + str(Global.score)
    $Depth.text = "Depth : " + str(Global.depth) + "m"


func _on_Retry_pressed():
    Global.is_retry = true
    get_tree().change_scene("res://Main.tscn")
