extends MarginContainer

func _ready():
    $Timer.connect("timeout", $HBoxContainer/ItemsOxygen/Oxygen/Oxygen ,
    "_on_oxygen_update")
