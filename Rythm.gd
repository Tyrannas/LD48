extends Node2D

export var RYTHM_DURATION = 2.0 # seconds
export var ACCEPTANCE_DELAY = 0.2 # seconds
export var MAX_OXYGEN = 5
export var OXYGEN_LOST = 1 # when suffocating
export var OXYGEN_GAINED = 1 # when breathing

var oxygen = MAX_OXYGEN

# Pour chaque biome : X touches à saisir séquentiellement
var biome_inputs = [
    ['ui_left', 'ui_right', 'ui_left', 'ui_right']
]
var biome_index = 0
var current_inputs = biome_inputs[biome_index]
var input_index = 0
var current_input = current_inputs[input_index]
var input_changed = false
var input_was_pressed = true
var fucked_the_rythm = false

func _update_oxygen():
    $Oxygen.text = str(oxygen)

func _ready():
    self._update_oxygen()
    $KeyTimer.connect("timeout", self, "_on_key_timer_timeout")
    $KeyTimer.wait_time = RYTHM_DURATION / len(current_inputs)
    $KeyTimer.start()
    $AcceptanceDelay.wait_time = ACCEPTANCE_DELAY
    $AcceptanceDelay.one_shot = true
    $AcceptanceDelay.connect("timeout", self, "_on_timeout_acceptance_delay")

func rythm_result():
    if input_index == current_inputs.size() - 1:
        # Toutes les notes du rythme ont été jouées
        input_index = 0
        if fucked_the_rythm:
            self._suffocate()
        else:
            self._breathe()
        fucked_the_rythm = false
    else:
        input_index += 1
    current_input = current_inputs[input_index]

func _on_key_timer_timeout():
    self.rythm_result()
    $Key.text = current_input
    input_changed = true
    input_was_pressed = false
    $AcceptanceDelay.start()
    
func _on_timeout_acceptance_delay():
    input_changed = false
    if not input_was_pressed:
        # TODO : Noircir la flèche correspondante pour que le joueur
        #        comprenne qu'il a raté la note
        fucked_the_rythm = true

func _breathe():
    if oxygen < MAX_OXYGEN:
        oxygen += OXYGEN_GAINED
    self._update_oxygen()

func _suffocate():
    oxygen -= OXYGEN_LOST
    if oxygen < 0:
        pass
        # GAME OVER ?
    else:
        self._update_oxygen()

func _process(delta):
    if input_changed and not input_was_pressed:
        if Input.is_action_pressed(current_input):
            input_was_pressed = true
            # TODO : Illuminer la flèche correspondante pour que le joueur
            #        comprenne qu'il est bien dans le rythme

# TODO : Lorsqu'on change de biome, mettre à jour :
# - le KeyTimer.wait_time
# - biome_index
# - current_inputs
