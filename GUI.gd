extends MarginContainer

var score = 0

func _ready():
    #TODO : remove the $Timer if we don't need it anymore
    pass

func _display_keys_to_press(keys_to_display):
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
    #TODO : Afficher les flèches à presser pour respirer
    pass

func _update_score(nb_coins):
    score += 10 * nb_coins

    $HBoxContainer/ItemsOxygen/Items/Gold/Background/Number.text = str(score)
