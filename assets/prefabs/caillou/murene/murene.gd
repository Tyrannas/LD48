extends Node2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play("rest")
    var speed = rng.randf_range(0.3, 0.7) * pow(-1, rng.randi() % 2)
    $AnimationPlayer.play("rest", -1, speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
