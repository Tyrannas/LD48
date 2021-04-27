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
var new_biome_infos = {}
var preserve_first = false

func _ready():
    $KeyTimer.connect("timeout", self, "_on_key_timer_timeout")    

func get_current_input():
    if biome_inputs:
        return biome_inputs[input_index]

func _get_next_index():
    return input_index + 1 if input_index < len(biome_inputs) - 1 else 0
    
func _reset_keys_pressed():
    keys_pressed = []
    for i in len(biome_inputs):
        var result = 1 if i == 0 and preserve_first else 0
        keys_pressed.append({
            "key": biome_inputs[i],
            "result": result,
            "is_current": i == 0,
        })
    input_index = 0
    rythm_fucked = false
    preserve_first = false
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

func _update_biome_infos():
    biome_inputs = new_biome_infos['inputs']
    $KeyTimer.wait_time = 60.0 / new_biome_infos['bpm']
    new_biome_infos = {}

func _update_biome_inputs(new_inputs, bpm):
    """The UI will be changed at the end of the rythm (in _on_key_timer_timeout)"""
    new_biome_infos = {'inputs': new_inputs, 'bpm': bpm}
    if not biome_inputs:
        # Initialisation for the first biome
        _update_biome_infos()
        $KeyTimer.start()
        _reset_keys_pressed()

func is_last_note_of_rythm():
    return input_index == biome_inputs.size() - 1

func _on_key_timer_timeout():
    update_keys_pressed_current(input_index+1)
    if not input_was_pressed:
        update_keys_pressed_result(-1)
    # Si toutes les notes du rythme ont été jouées
    if is_last_note_of_rythm():
        emit_signal("oxygen_signal", rythm_fucked)
        if new_biome_infos:
            _update_biome_infos()
        _reset_keys_pressed()
    else:
        emit_signal("keys_pressed_signal", keys_pressed)
        input_index += 1
    if keys_pressed[input_index]["result"] != 1:
        input_was_pressed = false
        
func __get_time():
    var time = OS.get_time()
    return String(time.hour) +":"+String(time.minute)+":"+String(time.second)
    
func _process(_delta):
    # TODO: handle feedback when rythmfucked is true
    if not rythm_fucked:
        for input in ["ui_left", "ui_right", "ui_up", "ui_down"]:
            if Input.is_action_just_pressed(input):
                if not input_was_pressed:
                    # si une touche n'a pas déjà été validée pour cet interval
                    _validate_input(input)
                    input_was_pressed = true
                else:
                    # If the player taps too early, the next note is wrong
                    # except if time left to complete <= wait_time / 3 and it's the right key
                    # then accept the key
                    if $KeyTimer.time_left < $KeyTimer.wait_time / 3:
                        _validate_input(input, _get_next_index())
                    else:
                        # else it's too early to validate the next key so set it failed
                        update_keys_pressed_result(-1, _get_next_index())

                emit_signal("keys_pressed_signal", keys_pressed)

func _validate_input(input, index=input_index):
    var input_to_check = get_current_input() if index == input_index  else biome_inputs[index]
    # est ce que c'est la bonne touche?
    if input == input_to_check:
        update_keys_pressed_result(1, index)
        if index != input_index and index == 0:
            # if the next key is the first one of the next sequence and was early pressed
            # prevent it from being reseted
            preserve_first = true
    else:
        update_keys_pressed_result(-1, index)
