extends Node2D

onready var state_machine := get_parent()
onready var actor := state_machine.get_parent()

var previous_target_position
var target_point_world : Vector2 = Vector2()

func _ready() -> void:
	var signal_status := SignalManager.connect("pathfinder_set_path", self, "_on_pathfinder_set_path")
	if signal_status != 0:
		print("Signal pathfinder_set_path failed with error code " + String(signal_status))
	state_machine.add_state("chase")

func _state_logic(_delta: float) -> void:	
	if state_machine.state == state_machine.states.chase:
		if actor.target:
			pass
#		if actor.target && actor.path.size() > 1:
#			if !previous_target_position || previous_target_position != actor.target.position:
#				previous_target_position = actor.target.position
#
#				var arrived_to_next_point : bool = move_to(target_point_world)
#
#				if arrived_to_next_point:
#					actor.path.remove(0)
#					if len(actor.path) == 0:
#						SignalManager.emit_signal("pathfinder_get_path", actor.get_path(), actor.position, actor.target.position)
#						return
#					target_point_world = actor.path[0]
#			else:
#				SignalManager.emit_signal("pathfinder_get_path", actor.get_path(), actor.position, actor.target.position)
#				return
	
func _get_transition(_delta: float) -> int:
	if actor.should_attack():
		return state_machine.states.attack
	elif actor.should_chase():
		return state_machine.states.chase	
	elif actor.should_be_dead():
		return state_machine.states.dead
	elif actor.should_be_idle():
		return state_machine.states.idle
	elif actor.should_patrol():
		return state_machine.states.patrol
	
	return state_machine.states.idle		
	
func _enter_state(_new_state: int, _old_state: int):
	if _new_state != _old_state:
		SignalManager.emit_signal("pathfinder_get_path", actor.get_path(), actor.position, actor.target.position)
	
func _exit_state(_old_state, _new_state):
	if _old_state != _new_state:
		pass

#func move_to(world_position: Vector2) -> bool:
#	var ARRIVE_DISTANCE := 10.0
#	var payload := []
#	payload.push_back(actor.position)
#	payload.push_back(world_position)
#
#	SignalManager.emit_signal("steering_follow_path", payload)
#
#	return actor.position.distance_to(world_position) < ARRIVE_DISTANCE
#
#func _on_pathfinder_set_path(actor_id: String, path: PoolVector2Array) -> void:
#	if actor_id == actor.get_path():
#		actor.path = path
#		if actor.path.size() > 1:
#			target_point_world = actor.path[1]
