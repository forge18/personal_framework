extends Node2D

export var use_seek: bool = false

export(float, 0, 2000, 40) var linear_speed_max := 120.0 setget set_linear_speed_max
export(float, 0, 200, 2) var linear_accel_max := 10.0 setget set_linear_accel_max
export(float, 0, 5, 0.1) var predict_time := 1.0 setget set_predict_time

var _blend: GSAIBlend

var _linear_drag_coefficient := 0.025
var _angular_drag := 0.1
var _direction_face := GSAIAgentLocation.new()


#onready var agent := GSAIKinematicBody2DAgent.new(self)
onready var actor := get_parent().get_parent().get_parent()
onready var accel := GSAITargetAcceleration.new()
onready var follow := GSAIPursue.new(actor.agent, actor.target, 0.5)	

onready var pursuer = self
onready var seeker = self


func _ready() -> void:
	setup(
		predict_time, 
		linear_speed_max, 
		linear_accel_max
	)
	
	actor.agent.calculate_velocities = false
	set_physics_process(false)


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return
	
	pursuer.agent.linear_speed_max = value
	seeker.agent.linear_speed_max = value


func set_linear_accel_max(value: float) -> void:
	linear_accel_max = value
	if not is_inside_tree():
		return
	
	pursuer.agent.linear_acceleration_max = value
	seeker.agent.linear_acceleration_max = value


func set_predict_time(value: float) -> void:
	predict_time = value
	if not is_inside_tree():
		return
	
	pursuer._behavior.predict_time_max = value


func setup(
			predict_time: float, 
			linear_speed_max: float, 
			linear_accel_max: float
	) -> void:
	var behavior: GSAISteeringBehavior
	if use_seek:
		behavior = GSAISeek.new(actor.agent, actor.target.agent)
	else:
		behavior = GSAIPursue.new(actor.agent, actor.target.agent, predict_time)
	
	var orient_behavior := GSAIFace.new(actor.agent, _direction_face)
	orient_behavior.alignment_tolerance = deg2rad(5)
	orient_behavior.deceleration_radius = deg2rad(5)
	
	_blend = GSAIBlend.new(actor.agent)
	_blend.add(behavior, 1)
	_blend.add(orient_behavior, 1)
	
	actor.agent.angular_acceleration_max = deg2rad(40)
	actor.agent.angular_speed_max = deg2rad(90)
	actor.agent.linear_acceleration_max = linear_accel_max
	actor.agent.linear_speed_max = linear_speed_max
	
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	_direction_face.position = actor.agent.position + accel.linear.normalized()
	
	_blend.calculate_steering(accel)

	actor.agent.angular_velocity = clamp(
			actor.agent.angular_velocity + accel.angular,
			-actor.agent.angular_speed_max,
			actor.agent.angular_speed_max
	)
	actor.agent.angular_velocity = lerp(actor.agent.angular_velocity, 0, _angular_drag)

	rotation += actor.agent.angular_velocity * delta
	
	var linear_velocity = (
			GSAIUtils.to_vector2(actor.agent.linear_velocity) +
			(GSAIUtils.angle_to_vector2(rotation) * -actor.agent.linear_acceleration_max)
	)
	linear_velocity = linear_velocity.clamped(actor.agent.linear_speed_max)
	linear_velocity = linear_velocity.linear_interpolate(
			Vector2.ZERO,
			_linear_drag_coefficient
	)
	
	linear_velocity = actor.move_and_slide(linear_velocity)
	actor.agent.linear_velocity = GSAIUtils.to_vector3(linear_velocity)

