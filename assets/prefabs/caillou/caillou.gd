extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    rng.randomize()
    var scale_nb = rng.randf_range(0.6, 1)
    scale = scale * Vector2(scale_nb, scale_nb)
    $AnimationPlayer.play("rest")
    var speed = rng.randf_range(0.3, 0.7) * pow(-1, rng.randi() % 2)
    $AnimationPlayer.play("rest", -1, speed)
    var display_murene = rng.randf_range(0, 1)
    print(display_murene)
    if display_murene > 0.3:
        $Murene.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
