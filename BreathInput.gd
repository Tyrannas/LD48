extends Node2D

var MARGIN_X = 10.0
var INPUTS_GROUP = "BreathInputs"
var OFFSET_INPUTS_Y = 500
var CURSOR_OFFSET = 0

var input_rotation = {
    'ui_up': 0,
    'ui_right': 90,
    'ui_down': 180,
    'ui_left': 270,
}

var cursor_picture = load("res://assets/sprites/cursor.png")
var arrows_pictures = {
    -1: load("res://assets/sprites/arrow_red.png"),
    0: load("res://assets/sprites/arrow.png"),
    1: load("res://assets/sprites/arrow_white.png")
}

var current_arrow_picture = load("res://assets/sprites/light_white.png")

var center = 0

var cursor = Sprite.new()
var cursor_start = center
var cursor_end = center
var total_margin = 10
var cursor_speed = 60

func _ready():
    cursor.set_texture(cursor_picture)
    total_margin = cursor.texture.get_size().x * cursor.scale.x + MARGIN_X
    center = get_viewport().size.x / 2.0
    cursor.position = Vector2(center, OFFSET_INPUTS_Y + CURSOR_OFFSET)
    add_child(cursor)
    cursor.hide()

func _handle_new_biome(speed, nb_arrows):
    # on veut bouger de total_margin par (60 / bpm)s 
    cursor_speed = total_margin / speed
    # ugly hack to get a sprite on position 0
    var first_sprite = get_key_sprites("ui_up", 1, nb_arrows, 0)
    var last_sprite = get_key_sprites("ui_up", 1, nb_arrows, nb_arrows - 1 )
    cursor_start = first_sprite.position.x - total_margin / 2
    cursor_end = last_sprite.position.x + total_margin / 2
    cursor.position.x = cursor_start + first_sprite.texture.get_width() / 2
    cursor.show()
    update()

func _process(delta):
    cursor.position.x += cursor_speed * delta 
    if cursor.position.x > cursor_end:
        cursor.position.x = cursor_start
    
func _draw():
    draw_line(Vector2(cursor_start, OFFSET_INPUTS_Y + CURSOR_OFFSET), Vector2(cursor_end, OFFSET_INPUTS_Y + CURSOR_OFFSET), Color.white, 1)
    
func get_key_sprites(input, result, keys_length, index):
    var sprite = Sprite.new()
    sprite.set_texture(arrows_pictures[result])
    sprite.rotation_degrees = input_rotation[input]
    var sprite_width = sprite.texture.get_size().x * sprite.scale.x + MARGIN_X
    # disgusting method to center the breathing keys
    sprite.position = Vector2(center - (keys_length * (sprite_width) / 2) + index * sprite_width, OFFSET_INPUTS_Y)
    return sprite
    
func _display_keys_to_press(keys_pressed):
    """Voilà à quoi ressemblera keys_to_display :
        [
            {
                "key": "ui_left,
                "result": 1,
                "is_current": false
            },
            {
                "key": "ui_right,
                "result": -1,
                "is_current": true
            },
                        {
                "key": "ui_left,
                "result": 0,
                "is_current": false
            },
        ]    
        Cela signifie :
        - que le rythme pour respirer est gauche - droite - gauche
        - que la première touche (gauche) a été pressée dans le bon timing (result=1)
        - que la deuxième touche (droite) n'a pas été pressée correctement (result=-1)
        - que la troisième touche (gauche) n'a pas encore été traitée (result=0)
        - que la touche actuelle à presser est la deuxième (is_current=true)
    """
    get_tree().call_group(INPUTS_GROUP, "queue_free")
    for i in len(keys_pressed):
        var key_pressed = keys_pressed[i]
        var sprite = self.get_key_sprites(key_pressed['key'], key_pressed['result'], len(keys_pressed), i)
        sprite.add_to_group(INPUTS_GROUP)
        add_child(sprite)
        
        if keys_pressed[i]["is_current"]:
            var current_input_sprite = sprite.duplicate()
            current_input_sprite.set_texture(current_arrow_picture)
            add_child(current_input_sprite)

