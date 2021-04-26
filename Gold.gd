extends Area2D

signal coin_collected

var COIN_VALUE = 10

func _on_body_entered(body):
    """
        Le sprite.visible = false permet de ne plus afficher la pièce à 
        l'écran le temps que la musique se joue. Sinon, la pièce reste 
        affichée jusqu'à la fin de la musique, ce qui créé un décalage
    """
    $AnimatedSprite.visible = false
    $Sound.play()
    Global.score += COIN_VALUE * Global.combo_multiplier
    emit_signal("coin_collected")
    yield($Sound, "finished")
    queue_free()
