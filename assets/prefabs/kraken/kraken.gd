extends Node2D

var rng = RandomNumberGenerator.new()
var animations = ["rest", "rest2"]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    rng.randomize()
    $Skeleton2D/"1".rotation_degrees = rng.randf_range(-50, 50)
    var animation = rng.randi_range(0, len(animations) - 1)
    var speed = rng.randf_range(0.3, 0.7) * pow(-1, rng.randi() % 2)
    $AnimationPlayer.play(animations[animation], -1, speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
