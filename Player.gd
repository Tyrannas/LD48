extends KinematicBody2D

var GRAVITY = 3000.0
var SPEED = 300.0
var velocity = Vector2.ZERO
var screen_size
var angle_pipe = 0
var flip_sprite = false
var depth = 0


func _ready():
    screen_size = get_viewport_rect().size
    $AnimationPlayer.play("Bouncing")

func _physics_process(delta):
    var direction = get_direction()
    var background_size = get_parent().background_size
    var sprite_size = $Sprite.texture.get_size() * $Sprite.scale
    var player_position_relative = get_global_transform_with_canvas().origin
    var max_pipe_size = $Pipe.texture.get_size()
    var top_of_viewport = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().position.y)
    var dist_player_top_viewport = player_position_relative.distance_to(top_of_viewport)
    
    velocity.x = SPEED * direction.x
    velocity.y = GRAVITY * delta
    velocity = move_and_slide(velocity)
    
    # Symétrie en cas de changement de côté
    if velocity.x < 0 :
        flip_sprite = false
    elif velocity.x > 0 :
        flip_sprite = true
    
    $Sprite.flip_h = flip_sprite
    
    # Pour éviter que le personnage sorte de l'écran (fonction clamp)
    # Et qu'il ne soit pas découpé en 2 (le clamp prenant le milieu de la sprite)
    # Ne pas oublier de faire * scale quand on rescale la sprite
    position.x = clamp(position.x, 0 + (sprite_size.x/2), screen_size.x - (sprite_size.x/2))
    position.y = clamp(position.y, 0, background_size.y - (sprite_size.y/2))
    
    $Pipe.position = Vector2(0,0)
    angle_pipe = $Pipe.get_global_transform().origin.angle_to_point(Vector2(background_size.x / 2, 0))
    # $Pipe.rotation = angle_pipe + PI
    $Pipe.scale.y = dist_player_top_viewport / max_pipe_size.y
    
    depth = int(position.y / 10.0)
    $Camera2D/CanvasLayer/GUI/HBoxContainer/HBoxContainer/Depth/Background/Number.text = str(depth) + "m"


func get_direction() -> Vector2:
    return Vector2(Input.get_action_strength("move_right") - 
        Input.get_action_strength("move_left"),
        1.0)
