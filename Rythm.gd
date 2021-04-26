extends Node2D

signal keys_pressed_signal
signal oxygen_signal
signal combo

# Pour chaque biome : X touches à saisir séquentiellement pour respirer
var biome_inputs = []
var input_index = 0
var keys_pressed = []
var input_was_pressed = false
var rythm_fucked = false
    
func _ready():
    $KeyTimer.connect("timeout", self, "_on_key_timer_timeout")    

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
    input_index = 0
    rythm_fucked = false
    emit_signal("keys_pressed_signal", keys_pressed)

func update_keys_pressed_result(result, index=input_index):
    if result == -1:
        rythm_fucked = true
        Global.combo_multiplier = 1
        emit_signal('combo')
        for i in len(keys_pressed):
            keys_pressed[i]['result'] = result
    else:
        keys_pressed[index]['result'] = result
        
func update_keys_pressed_current(index):
    for i in len(keys_pressed):
        keys_pressed[i]['is_current'] = i == index

func _update_biome_inputs(new_inputs, bpm):
    print("BIOME UPDATE")
    biome_inputs = new_inputs
    if not $KeyTimer.is_stopped():
        $KeyTimer.stop()
    $KeyTimer.wait_time = 60.0 / bpm
    $KeyTimer.start()
    self._reset_keys_pressed()

func is_last_note_of_rythm():
    return input_index == biome_inputs.size() - 1
    
func _on_key_timer_timeout():
    self.update_keys_pressed_current(input_index+1)
    if not input_was_pressed:
        self.update_keys_pressed_result(-1)
    # Si toutes les notes du rythme ont été jouées
    if self.is_last_note_of_rythm():
        emit_signal("oxygen_signal", rythm_fucked)
        self._reset_keys_pressed()
    else:
        emit_signal("keys_pressed_signal", keys_pressed)
        input_index += 1
    input_was_pressed = false

func _process(delta):
    if not rythm_fucked:
        for input in ["ui_left", "ui_right", "ui_up", "ui_down"]:
            if Input.is_action_just_pressed(input):
                if not input_was_pressed:
                    if input == self.get_current_input():
                        self.update_keys_pressed_result(1)
                    else:
                        self.update_keys_pressed_result(-1)
                    input_was_pressed = true
                else:
                    # If the player taps too early, the next note is wrong
                    # (except if it's the last note of the combo)
                    if not self.is_last_note_of_rythm():
                        self.update_keys_pressed_result(-1, input_index + 1)
            emit_signal("keys_pressed_signal", keys_pressed)
