extends CanvasLayer

func _ready():
    
    $Score.text = "Score : " + str(Global.score)
    $Depth.text = "Depth : " + str(Global.depth) + "m"
    
    if Global.is_dead == true:
        $GameOver.visible = true
        $Text.text = "Game over"
    else :
        $GameEnd.visible = true
        $Text.text = "Hurray !"
        var t = Timer.new()
        t.set_wait_time(1.5)
        t.set_one_shot(true)
        self.add_child(t)
        t.start()
        yield(t, "timeout")
        $GameEnd/AnimationPlayer.play("Remove_the_head")
        $GameEnd/EasterEgg.visible = true
        
    
    
    


func _on_Retry_pressed():
    Global.is_retry = true
    get_tree().change_scene("res://Main.tscn")
