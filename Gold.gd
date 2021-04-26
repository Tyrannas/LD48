extends Area2D

signal coin_collected

func _on_body_entered(_body):
    """
        Le sprite.visible = false permet de ne plus afficher la pièce à 
        l'écran le temps que la musique se joue. Sinon, la pièce reste 
        affichée jusqu'à la fin de la musique, ce qui créé un décalage
    """
    $AnimatedSprite.visible = false
    $Sound.play()
    Global.score += Global.coin_value * Global.combo_multiplier
    emit_signal("coin_collected")
    yield($Sound, "finished")
    queue_free()
