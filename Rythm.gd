extends Node2D

signal keys_pressed_signal
signal oxygen_signal

export var RYTHM_DURATION = 2.0 # seconds

# Pour chaque biome : X touches à saisir séquentiellement pour respirer
var biome_inputs = []
var input_index = 0
var keys_pressed = []
var input_was_pressed = false
var rythm_fucked = false
    
func get_current_input():
    return biome_inputs[input_index]

func _reset_keys_pressed():
    keys_pressed = []
    for i in len(biome_inputs):
        keys_pressed.append({
            "key": biome_inputs[i],
            "result": 0,
            "is_current": i == 0,
        })
    print("Keys pressed after reset : " + str(keys_pressed))
    input_index = 0
    if biome_inputs:
        $Key.text = self.get_current_input()
    rythm_fucked = false
    emit_signal("keys_pressed_signal", keys_pressed)

func update_keys_pressed_result(result):
    keys_pressed[input_index]['result'] = result
    if result == -1:
        rythm_fucked = true

func update_keys_pressed_current(index):
    for i in len(keys_pressed):
        keys_pressed[i]['is_current'] = i == index

func _update_biome_inputs(new_inputs):
    print("BIOME UPDATE")
    biome_inputs = new_inputs
    if not $KeyTimer.is_stopped():
        $KeyTimer.stop()
    $KeyTimer.wait_time = RYTHM_DURATION / len(biome_inputs)
    $KeyTimer.start()
    self._reset_keys_pressed()

func _ready():
    $KeyTimer.connect("timeout", self, "_on_key_timer_timeout")

func _on_key_timer_timeout():
    self.update_keys_pressed_current(input_index+1)
    
    # Si toutes les notes du rythme ont été jouées
    if input_index == biome_inputs.size() - 1:
        emit_signal("oxygen_signal", rythm_fucked)
        self._reset_keys_pressed()
    else:
        if not input_was_pressed:
            self.update_keys_pressed_result(-1)
        emit_signal("keys_pressed_signal", keys_pressed)
        print("Trop tard : " + str(keys_pressed))
        
        input_index += 1
    $Key.text = self.get_current_input()
    input_was_pressed = false

func _process(delta):
    if not input_was_pressed:
        for input in ["ui_left", "ui_right", "ui_up", "ui_down"]:
            if Input.is_action_pressed(input):
                input_was_pressed = true
                if input == self.get_current_input():
                    self.update_keys_pressed_result(1)
                    print("Nice : " + str(keys_pressed))
                else:
                    self.update_keys_pressed_result(-1)
                    print("Failed : " + str(keys_pressed))
                emit_signal("keys_pressed_signal", keys_pressed)
