extends KinematicBody2D

var gravity := 3000.0
var velocity := Vector2.ZERO
var speed := 300.0
var screen_size

func _ready():
    screen_size = get_viewport_rect().size

func _physics_process(delta):
    var direction = get_direction()
    var background_size = get_parent().background_size.y
    var sprite_size = $Sprite.texture.get_size() * $Sprite.scale
    
    velocity.x = speed * direction.x
    velocity.y = gravity * delta
    velocity = move_and_slide(velocity)
    
    # Pour éviter que le personnage sorte de l'écran (fonction clamp)
    # Et qu'il ne soit pas découpé en 2 (le clamp prenant le milieu de la sprite)
    # Ne pas oublier de faire * scale quand on rescale la sprite
    position.x = clamp(position.x, 0 + (sprite_size.x/2), screen_size.x - (sprite_size.x/2))
    position.y = clamp(position.y, 0, background_size - (sprite_size.y/2))
    
    $Camera2D.limit_bottom = background_size    

func get_direction() -> Vector2:
    return Vector2(Input.get_action_strength("move_right") - 
        Input.get_action_strength("move_left"),
        1.0)
