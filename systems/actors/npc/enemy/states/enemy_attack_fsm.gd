extends Node2D

onready var state_machine := get_parent()
onready var actor := state_machine.get_parent()

func _ready() -> void:
	state_machine.add_state("attack")
	
### Ongoing events
func _state_logic(_delta: float) -> void:
	pass

### Determines if transition allowed	
func _get_transition(_delta: float) -> int:
	if actor.should_attack():
		return state_machine.states.attack
	elif actor.should_chase():
		return state_machine.states.chase	
	elif actor.should_be_dead():
		return state_machine.states.dead
	elif actor.should_patrol():
		return state_machine.states.patrol1
	elif actor.should_be_idle():
		return state_machine.states.idle
	
	return state_machine.states.idle
	
	
### Events upon entering state
func _enter_state(_new_state: int, _old_state: int) -> void:
	pass

### Events upon exiting state	
func _exit_state(_old_state: int, _new_state:int) -> void:
	pass
