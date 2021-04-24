extends Node2D

export var max_oxygen = 5
var margin_x = 10
var oxygen = max_oxygen
var logos = []

func _ready():
    $Sprite.visible = false    
    for i in max_oxygen:
        var tp = $Sprite.duplicate()
        add_child(tp)
        tp.position = Vector2(i * (tp.texture.get_size().x * tp.scale.x + margin_x), 0)
        tp.visible = true
        logos.append(tp)
        
func _on_oxygen_update():
    if oxygen > 0 :
        oxygen -= 1
        for i in oxygen:
            logos[i].visible = true
        for i in range(oxygen, max_oxygen):
            logos[i].visible = false
