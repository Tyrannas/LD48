extends Node2D

var MARGIN_X = 10.0
var INPUTS_GROUP = "BreathInputs"

var input_rotation = {
    'ui_up': 0,
    'ui_right': 90,
    'ui_down': 180,
    'ui_left': 270,
}

var arrows_pictures = {
    -1: load("res://assets/arrow_red.png"),
    0: load("res://assets/arrow.png"),
    1: load("res://assets/arrow_white.png")
}

var current_arrow_picture = load("res://assets/light.png")

var center = 0

func _ready():
    center = get_viewport().size.x / 2.0

func get_key_sprites(input, result, keys_length, index):
    var sprite = Sprite.new()
    sprite.set_texture(arrows_pictures[result])
    sprite.rotation_degrees = input_rotation[input]
    var sprite_width = sprite.texture.get_size().x * sprite.scale.x + MARGIN_X
    # disgusting method to center the breathing keys
    sprite.position = Vector2(center - (keys_length * (sprite_width) / 2) + index * sprite_width, 0)
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
