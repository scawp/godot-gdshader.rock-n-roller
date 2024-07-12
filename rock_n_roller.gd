extends Node2D

signal rock_n_roller_finished()

@export_category("Easing Settings")
@export_exp_easing() var easing = -2.0
@export_range(0.0, 10.0, 0.1) var ease_in = 0.5
@export_range(0.0, 10.0, 0.1) var ease_out = 4.0

@export_category("Default Modes")
@export_flags("fade", "rock", "roll", "bounce") var default_flags = 15

@export_category("Advanced")
@export_range(0.0, 5.0, 0.1) var fade_delay = 0.0
@export var time_override: bool = false

@onready var _parent = get_parent()

@onready var _bounce = _parent.material.get_shader_parameter("enableBounce"):
	set(value):
		_bounce = clampf(value, 0.0, 1.0)
		_parent.material.set_shader_parameter("enableBounce", ease(_bounce, easing))

@onready var _roll = _parent.material.get_shader_parameter("enableRoll"):
	set(value):
		_roll = clampf(value, 0.0, 1.0)
		_parent.material.set_shader_parameter("enableRoll", ease(_roll, easing))
			
@onready var _rock = _parent.material.get_shader_parameter("enableRock"):
	set(value):
		_rock = clampf(value, 0.0, 1.0)
		_parent.material.set_shader_parameter("enableRock", ease(_rock, easing))

@onready var _fade = _parent.material.get_shader_parameter("fadeOut"):
	set(value):
		_fade = clampf(value, 0.0, 1.0 + fade_delay)
		#print(_fade)
		_parent.material.set_shader_parameter("fadeOut", ease(_fade, easing))

var time := 0.0

var callables = {}
var deletables = []
#var callables: Array[Callable] = []
var signal_on_finished = false

var fade_in = func(delta) :
	_fade += delta / ease_in
	if _fade >= 1.0: 
		_fade = 1.0 + fade_delay
		deletables.append("fade")

var fade_out = func(delta) :
	if _fade > 1.0:
		_fade -= delta
	else:
		_fade -= delta / ease_out
	if _fade == 0.0: deletables.append("fade")
	
var fade_in_out = func(delta) :
	_fade += delta / ease_in
	if _fade >= 1.0: 
		_fade = 1.0 + fade_delay
		callables["fade"] = fade_out

var rock_in = func(delta) :
	_rock += delta / ease_in
	if _rock == 1.0: deletables.append("rock")
	
var rock_out = func(delta) :
	_rock -= delta / ease_out
	if _rock == 0.0: deletables.append("rock")
	
var rock_in_out = func(delta) :
	_rock += delta / ease_in
	if _rock == 1.0: callables["rock"] = rock_out
	
var roll_in = func(delta) :
	_roll += delta / ease_in
	if _roll == 1.0: deletables.append("roll")

var roll_out = func(delta) :
	_roll -= delta / ease_out
	if _roll == 0.0: deletables.append("roll")
	
var roll_in_out = func(delta) :
	_roll += delta / ease_in
	if _roll == 1.0: callables["roll"] = roll_out

var bounce_in = func(delta) :
	_bounce += delta / ease_in
	if _bounce == 1.0: deletables.append("bounce")
	
var bounce_out = func(delta) :
	_bounce -= delta / ease_out
	if _bounce == 0.0: deletables.append("bounce")

var bounce_in_out = func(delta) :
	_bounce += delta / ease_in
	if _bounce == 1.0: callables["bounce"] = bounce_out


func _ready():
	#TODO: check for material or die
	_parent.material = _parent.material.duplicate() #workaround as I couldn't get this to work via the editor
	#TODO: check other types for quirks
	#This isn't needed for Sprite2D (offset is taken into account)
	if _parent is Label:
		_parent.material.set_shader_parameter("pivotPoint", _parent.size / 2)

	_parent.material.set_shader_parameter("timeOverride", time_override)

	#print(default_flags)

func _process(delta):
	for calls in callables:
		callables[calls].call(delta)
	#print(callables)
	
	for deletes in deletables:
		callables.erase(deletes)
	deletables.clear()
	
	if callables.is_empty():
		if signal_on_finished:
			signal_on_finished = false
			rock_n_roller_finished.emit()
			print("Finished")
			
		time = 0.0
	else:
		if time_override:
			time += delta
			_parent.material.set_shader_parameter("phase", time)


#flags can be set in advanced signal properties, or default to export
func _on_trigger_on(flags = default_flags, set_signal_on_finished = false):
	if !flags: flags = default_flags
	if flags & 0b0001: callables["fade"] = fade_in
	if flags & 0b0010: callables["rock"] = rock_in
	if flags & 0b0100: callables["roll"] = roll_in
	if flags & 0b1000: callables["bounce"] = bounce_in
	signal_on_finished = set_signal_on_finished

func _on_trigger_off(flags = default_flags, set_signal_on_finished = false):
	if !flags: flags = default_flags
	if flags & 0b0001: callables["fade"] = fade_out
	if flags & 0b0010: callables["rock"] = rock_out
	if flags & 0b0100: callables["roll"] = roll_out
	if flags & 0b1000: callables["bounce"] = bounce_out
	signal_on_finished = set_signal_on_finished

func _on_trigger_ping(flags = default_flags, set_signal_on_finished = false):
	if !flags: flags = default_flags
	if flags & 0b0001: callables["fade"] = fade_in_out
	if flags & 0b0010: callables["rock"] = rock_in_out
	if flags & 0b0100: callables["roll"] = roll_in_out
	if flags & 0b1000: callables["bounce"] = bounce_in_out
	signal_on_finished = set_signal_on_finished
