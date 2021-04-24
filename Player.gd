extends KinematicBody2D

var gravity := 3000.0
var velocity := Vector2.ZERO
var speed := 300.0

func _physics_process(delta):
	var direction := get_direction()
	
	velocity.x = speed * direction.x
	velocity.y = gravity * delta
	velocity = move_and_slide(velocity)
	
func get_direction() -> Vector2:
	return Vector2(Input.get_action_strength("move_right") - 
		Input.get_action_strength("move_left"),
		1.0)
