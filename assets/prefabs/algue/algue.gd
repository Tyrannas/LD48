extends Node2D

var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    rng.randomize()
    var scale_nb = rng.randf_range(0.6, 1)
    scale = scale * Vector2(scale_nb, scale_nb)
    $Skeleton2D/Bone2D.rotation_degrees = rng.randf_range(-15, 50)
    var speed = rng.randf_range(0.3, 0.7) * pow(-1, rng.randi() % 2)
    $AnimationPlayer.play("rest", -1, speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
