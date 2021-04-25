extends Node2D

signal keys_pressed_signal
signal oxygen_signal

export var RYTHM_DURATION = 2.0 # seconds
#export var ACCEPTANCE_DELAY = 0.2 # seconds

# Pour chaque biome : X touches à saisir séquentiellement pour respirer
var biome_inputs = []
var input_index = 0
var keys_pressed = []
var input_was_pressed = false
var rythm_fucked = false
    
func get_current_input():
    return biome_inputs[input_index]

func _reset_keys_pressed():
    """"
    For each key, we tell the GUI if the key is :
    - not yet pressed : 0
    - pressed correctly : 1
    - not pressed (or in the wrong timing) : -1
    """
    keys_pressed = []
    for input in biome_inputs:
        keys_pressed.append([input, 0])
    input_index = 0
    if biome_inputs:
        $Key.text = self.get_current_input()
    rythm_fucked = false

func update_keys_pressed(result):
    for i in len(keys_pressed):
        keys_pressed[i][1] = 0
    keys_pressed[input_index][1] = result

func _update_biome_inputs(new_inputs):
    biome_inputs = new_inputs
    $KeyTimer.stop()
    $KeyTimer.wait_time = RYTHM_DURATION / len(biome_inputs)
    $KeyTimer.start()
    self._reset_keys_pressed()
    emit_signal("keys_pressed_signal", keys_pressed)

func _ready():
    $KeyTimer.connect("timeout", self, "_on_key_timer_timeout")
#    $AcceptanceDelay.wait_time = ACCEPTANCE_DELAY
#    $AcceptanceDelay.one_shot = true
#    $AcceptanceDelay.connect("timeout", self, "_on_timeout_acceptance_delay")

func rythm_result():
    emit_signal("oxygen_signal", rythm_fucked)
    self._reset_keys_pressed()

func _on_key_timer_timeout():
    if not input_was_pressed:
        self.update_keys_pressed(-1)
        rythm_fucked = true
    emit_signal("keys_pressed_signal", keys_pressed)
    print("Oops raté : " + str(keys_pressed))
    
    # Si toutes les notes du rythme ont été jouées
    if input_index == biome_inputs.size() - 1:
        self.rythm_result()
    else:
        input_index += 1
    $Key.text = self.get_current_input()
    input_was_pressed = false
#    $AcceptanceDelay.start()
    
#func _on_timeout_acceptance_delay():
#    input_changed = false
#    if not input_was_pressed:
#        keys_pressed[input_index] = -1

func _process(delta):
    if not input_was_pressed:
        if Input.is_action_pressed(self.get_current_input()):
            input_was_pressed = true
            self.update_keys_pressed(1)
            emit_signal("keys_pressed_signal", keys_pressed)
            print("Nice : " + str(keys_pressed))

# TODO : Lorsqu'on change de biome, mettre à jour :
# - le KeyTimer.wait_time
# - input_index
# - keys_pressed
# - signaler à l'UI que les inputs ont changé
