extends Area2D

signal coin_collected

func _on_body_entered(body):
    """
        Le sprite.visible = false permet de ne plus afficher la pièce à 
        l'écran le temps que la musique se joue. Sinon, la pièce reste 
        affichée jusqu'à la fin de la musique, ce qui créé un décalage
    """
    $Sprite.visible = false
    $Sound.play()
    emit_signal("coin_collected", 1)
    yield($Sound, "finished")
    queue_free()
