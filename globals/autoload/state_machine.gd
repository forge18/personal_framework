extends Node2D

var state: int = -1 setget set_state
var previous_state: int= -1
var states: Dictionary = {}

onready var parent = get_parent()

func _physics_process(delta: float) -> void:
	if state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)

func _state_logic(_delta: float) -> void:
	pass
	
func _get_transition(_delta: float):
	return null
	
func _enter_state(_new_state: int, _old_state: int) -> void:
	pass
	
func _exit_state(_old_state: int, _new_state: int) -> void:
	pass
	
func set_state(new_state) -> void:
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:	
		_enter_state(new_state, previous_state)
		
func add_state(state_name):
	states[state_name] = states.size()
