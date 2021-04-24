extends Node2D

signal keys_pressed_signal
signal oxygen_signal

export var RYTHM_DURATION = 2.0 # seconds
#export var ACCEPTANCE_DELAY = 0.2 # seconds
export var MAX_OXYGEN = 5

var oxygen = MAX_OXYGEN

# Pour chaque biome : X touches à saisir séquentiellement
var biome_inputs = [
    ['ui_left', 'ui_right']
]
var biome_index = 0
var current_inputs = biome_inputs[biome_index]
var input_index = 0
var current_input = current_inputs[input_index]
var keys_pressed = []
var input_changed = false
var input_was_pressed = false

func _reset_keys_pressed():
    """"
    For each key, we tell the GUI if the key is :
    - not yet pressed : 0
    - pressed correctly : 1
    - not pressed (or in the wrong timing) : -1
    """
    keys_pressed = []
    for input in current_inputs:
        keys_pressed.append([input, 0])
    input_index = 0

func _ready():
    self._reset_keys_pressed()
    print("Ready : " + str(keys_pressed))
    emit_signal("keys_pressed_signal", keys_pressed)
    $KeyTimer.connect("timeout", self, "_on_key_timer_timeout")
    $KeyTimer.wait_time = RYTHM_DURATION / len(current_inputs)
    $KeyTimer.start()
#    $AcceptanceDelay.wait_time = ACCEPTANCE_DELAY
#    $AcceptanceDelay.one_shot = true
#    $AcceptanceDelay.connect("timeout", self, "_on_timeout_acceptance_delay")

func rythm_result():
    var rythm_fucked = false
    for key_pressed in keys_pressed:
        if key_pressed[1] == -1 :
            rythm_fucked = true
        break
    emit_signal("oxygen_signal", rythm_fucked)
    if rythm_fucked:
        print("Oxygen missing : " + str(keys_pressed))
    else:
        print("Full combo ! " + str(keys_pressed))
    self._reset_keys_pressed()
    emit_signal("keys_pressed_signal", keys_pressed)
    print("Reset : " + str(keys_pressed))

func _on_key_timer_timeout():
    if not input_was_pressed:
        keys_pressed[input_index][1] = -1
    if input_index == current_inputs.size() - 1:
        # Toutes les notes du rythme ont été jouées
        self.rythm_result()
    else:
        emit_signal("keys_pressed_signal", keys_pressed)
        print("Oops raté : " + str(keys_pressed))
        input_index += 1
    current_input = current_inputs[input_index]
    $Key.text = current_input
    input_changed = true
    input_was_pressed = false
#    $AcceptanceDelay.start()
    
#func _on_timeout_acceptance_delay():
#    input_changed = false
#    if not input_was_pressed:
#        keys_pressed[input_index] = -1

func _process(delta):
    if input_changed and not input_was_pressed:
        if Input.is_action_pressed(current_input):
            input_was_pressed = true
            keys_pressed[input_index][1] = 1
            emit_signal("keys_pressed_signal", keys_pressed)
            print("Nice : " + str(keys_pressed))

# TODO : Lorsqu'on change de biome, mettre à jour :
# - le KeyTimer.wait_time
# - biome_index
# - current_inputs
# - keys_pressed
# - signaler à l'UI que les inputs ont changé
