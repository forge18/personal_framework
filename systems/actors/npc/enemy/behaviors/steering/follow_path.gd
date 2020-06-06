extends Node2D


var _velocity := Vector2.ZERO
var _accel := GSAITargetAcceleration.new()
var _valid = false
var _drag := 0.1


export(float, 0, 2000, 50) var linear_speed_max := 600.0 setget set_linear_speed_max
export(float, 0, 200, 10.0) var linear_acceleration_max := 40.0 setget set_linear_acceleration_max
export(float, 0, 100, 0.1) var arrival_tolerance := 10.0 setget set_arrival_tolerance
export(float, 0, 500, 10) var deceleration_radius := 100.0 setget set_deceleration_radius
export(float, 0, 5, 0.1) var predict_time := 0.3 setget set_predict_time
export(float, 0, 200, 10.0) var path_offset := 20.0 setget set_path_offset


onready var actor := get_parent().get_parent().get_parent()
onready var agent = actor.agent
onready var path := GSAIPath.new([
		Vector3(actor.global_position.x, actor.global_position.y, 0),
		Vector3(actor.global_position.x, actor.global_position.y, 0)
	], true)
onready var follow := GSAIFollowPath.new(agent, path, 0, 0)	


func _ready() -> void:
	setup(
			path_offset,
			predict_time,
			linear_acceleration_max,
			linear_speed_max,
			deceleration_radius,
			arrival_tolerance
	)


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return
	
	agent.linear_speed_max = value * 10


func set_linear_acceleration_max(value: float) -> void:
	linear_acceleration_max = value
	if not is_inside_tree():
		return
	
	agent.linear_acceleration_max = value * 10


func set_arrival_tolerance(value: float) -> void:
	arrival_tolerance = value
	if not is_inside_tree():
		return
	
	follow.arrival_tolerance = value


func set_deceleration_radius(value: float) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return
	
	follow.deceleration_radius = value


func set_predict_time(value: float) -> void:
	predict_time = value
	if not is_inside_tree():
		return
	
	follow.prediction_time = value


func set_path_offset(value: float) -> void:
	path_offset = value
	if not is_inside_tree():
		return
	
	follow.path_offset = value


func setup(
			path_offset: float,
			predict_time: float,
			accel_max: float,
			speed_max: float,
			decel_radius: float,
			arrival_tolerance: float
	) -> void:
	var signal_status = SignalManager.connect("steering_follow_path", self, "_on_steering_follow_path")
	if signal_status != 0:
		print("Signal steering_follow_path failed with error code " + String(signal_status))
		
	follow.path_offset = path_offset
	follow.prediction_time = predict_time
	follow.deceleration_radius = decel_radius
	follow.arrival_tolerance = arrival_tolerance
	
	agent.linear_acceleration_max = accel_max
	agent.linear_speed_max = speed_max
	agent.linear_drag_percentage = _drag


func _physics_process(delta: float) -> void:
	if _valid:
		follow.calculate_steering(_accel)
		actor.agent._apply_steering(_accel, delta)


func _on_steering_follow_path(points: Array) -> void:
	var positions := PoolVector3Array()
	for p in points:
		positions.append(Vector3(p.x, p.y, 0))
	path.create_path(positions)
	_valid = true
