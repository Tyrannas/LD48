extends MarginContainer

var score = 0

func _ready():
    #TODO : remove the $Timer if we don't need it anymore
    pass


func _update_score(nb_coins):
    score += 10 * nb_coins

    $HBoxContainer/ItemsOxygen/Items/Gold/Background/Number.text = str(score)
