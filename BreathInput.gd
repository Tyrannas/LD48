extends Node2D

var MARGIN_X = 10
var INITIAL_POSITION = Vector2(113, 7)
var INPUTS_GROUP = "BreathInputs"

var input_rotation = {
    'ui_up': 0,
    'ui_right': 90,
    'ui_down': 180,
    'ui_left': 270,
}

var arrows = {
    -1: load("res://assets/arrow_red.png"),
    0: load("res://assets/arrow.png"),
    1: load("res://assets/arrow_white.png")
}

func _display_keys_to_press(keys_pressed):
    """Voilà à quoi ressemblera keys_to_display :
        [
            ["ui_left", 1], 
            ["ui_right", -1], 
            ["ui_left", 0],
        ]    
        Cela signifie :
        - que le rythme pour respirer est gauche - droite - gauche
        - que la première touche (gauche) a été pressée dans le bon timing (1)
        - que la deuxième touche (droite) n'a pas été pressée (-1)
        - que la troisième touche (gauche) n'est pas encore arrivée (0)
    """
    get_tree().call_group(INPUTS_GROUP, "queue_free")
    for i in len(keys_pressed):
        var input = keys_pressed[i][0]
        var result = keys_pressed[i][1]
        var sprite = Sprite.new()
        sprite.set_texture(arrows[result])
        sprite.position = INITIAL_POSITION
        sprite.position = Vector2(i * (sprite.texture.get_size().x * sprite.scale.x + MARGIN_X), 0)
        sprite.rotation_degrees = input_rotation[input]
        sprite.add_to_group(INPUTS_GROUP)
        add_child(sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
