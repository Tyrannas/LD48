extends MarginContainer


func _ready():
    #TODO : remove the $Timer if we don't need it anymore
    pass


func _update_score(nb_coins):
    Global.score += 10 * nb_coins

    $VBoxContainer/HBoxContainer/ItemsOxygen/Items/Gold/Background/Number.text = str(Global.score)
