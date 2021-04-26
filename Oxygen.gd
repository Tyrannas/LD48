extends Node2D

signal game_over
signal combo

export var MAX_OXYGEN = 7
export var OXYGEN_LOST = 1 # when failing the rythm
export var OXYGEN_GAINED = 1 # when succeding the rythm

var margin_x = 10
var oxygen = MAX_OXYGEN
var logos = []


func _ready():
    $Sprite.visible = false    
    for i in MAX_OXYGEN:
        var tp = $Sprite.duplicate()
        add_child(tp)
        tp.position = Vector2(i * (tp.texture.get_size().x * tp.scale.x + margin_x), 0)
        tp.visible = true
        logos.append(tp)
        
func _update_oxygen(rythm_fucked):
    """
    rythm_fucked vaudra :
        - true s'il faut augmenter l'oxygène (rythme respecté)
        - false s'il faut le diminuer (rythme raté)
    """
    if rythm_fucked:
        $Gloups.play()
        oxygen = max(oxygen - OXYGEN_LOST, 0)
        if oxygen == 0 :
            Global.is_dead = true
            emit_signal("game_over") 
    else:
        $Breath.play()
        oxygen = min(oxygen + OXYGEN_GAINED, MAX_OXYGEN)
        Global.combo_multiplier += 1
        emit_signal("combo")
    for i in oxygen:
        logos[i].visible = true
    for i in range(oxygen, MAX_OXYGEN):
        logos[i].visible = false

