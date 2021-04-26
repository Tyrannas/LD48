extends MarginContainer


func _update_score():
    $VBoxContainer/HBoxContainer/ItemsOxygen/Items/Gold/Background/Number.text = str(Global.score)

func _update_combo_multiplier():
    var combo_box = $VBoxContainer/HBoxContainer/ItemsOxygen/Items/Gold/Background/Combo
    if Global.combo_multiplier > 1:
        combo_box.text = "x" + str(Global.combo_multiplier)
        combo_box.visible = true
    else:
        combo_box.visible = false
