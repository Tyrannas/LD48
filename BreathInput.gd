extends Node2D

var MARGIN_X = 10
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
        var input = keys_pressed[i]["key"]
        var result = keys_pressed[i]["result"]
        var sprite = Sprite.new()
        sprite.set_texture(arrows_pictures[result])
        sprite.position = Vector2(i * (sprite.texture.get_size().x * sprite.scale.x + MARGIN_X), 0)
        sprite.rotation_degrees = input_rotation[input]
        sprite.add_to_group(INPUTS_GROUP)
        add_child(sprite)
        if keys_pressed[i]["is_current"]:
            var current_input_sprite = sprite.duplicate()
            current_input_sprite.set_texture(current_arrow_picture)
            add_child(current_input_sprite)
        


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
