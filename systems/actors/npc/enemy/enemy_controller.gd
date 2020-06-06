extends KinematicBody2D

var target = null
var path := []

var agent := GSAIKinematicBody2DAgent.new(self)
var velocity: Vector2 = Vector2()
export(float) var speed: float = 150
export(int) var distance_threshold: int = 35

onready var state_machine := $States
onready var states: Dictionary = state_machine.states

func _ready():
	var _bodyEnterConnection := $Area2D.connect("body_entered", self, '_on_DetectRadius_body_entered')
	var _bodyExitConnection := $Area2D.connect("body_exited", self, '_on_DetectRadius_body_exited')


###############################################
################### SIGNALS ###################
###############################################
func _on_DetectRadius_body_entered(body) -> void:
	if body.get_name() == "Player":
		target = body
		print(target)

func _on_DetectRadius_body_exited(body) -> void:
	#if !$Area2D.overlaps_body(body):
	if body.get_name() == "Player":
		target = null
		path.clear()
		
###############################################
############# STATE DETERMINATION #############
###############################################
func should_patrol() -> bool:
	var rules = \
		target == null
	return rules
	
func should_chase() -> bool:
	var rules = \
		target != null && \
		position.distance_to(target.position) > distance_threshold
	return rules
	
func should_attack() -> bool:
	var rules = \
		target != null && \
		position.distance_to(target.position) <= distance_threshold
	return rules
	
func should_be_dead() -> bool:
	var rules = \
		target != null && \
		position.distance_to(target.position) <= distance_threshold
	return rules

func should_be_idle() -> bool:
	var rules = \
		!self.should_patrol() && \
		!self.should_chase() && \
		!self.should_attack() && \
		!self.should_be_dead()
	return rules

