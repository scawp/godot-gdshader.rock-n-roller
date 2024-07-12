extends Node2D

func _ready():
	$"Sprite2d with Shader with Code/RockAndRollerController".connect("rock_n_roller_finished", _destroy)


func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton) and event.pressed:
		#hide()
		$"Sprite2d with Shader with Code/RockAndRollerController"._on_trigger_ping(11, true)


func _destroy():
	print("deleting Duck")
	queue_free()
