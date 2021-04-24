extends Area2D

signal coin_collected

func _on_body_entered(body):
    emit_signal("coin_collected", 1)
    queue_free()
