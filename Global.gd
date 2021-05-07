extends Node

var MODE = "normal"
var score = 0
var is_dead = false
var is_retry = false
var depth = 0
var combo_multiplier = 1
var coin_value = 10

func __get_time():
    """
    utility function to log times
    """
    var time = OS.get_time()
    return String(time.hour) +":"+String(time.minute)+":"+String(time.second)+" - "
