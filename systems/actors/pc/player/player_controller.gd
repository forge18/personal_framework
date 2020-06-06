extends KinematicBody2D

signal direction_changed

onready var agent := GSAISteeringAgent.new()

var path := null
var player_motion: Vector2 = Vector2()
var anim: String = "idle"

export(int) var SPEED : int = 400

enum PlayerState {
	IDLE,
	WALKING,
	RUNNING,
	STUNNED
}

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if GameVariables.game_mode == GameVariables.GameMode.BATTLE:
		battle_inputs(delta)
	else:
		explore_inputs(delta)
	
	
########## 8 Direction Orthogonal Movement ###########	
func explore_inputs(delta: float) -> void:		
	# Everything works like you're used to in a top-down game
	var direction: Vector2 = Vector2()
	
	var _lmb := Input.is_action_pressed("lmb")
	var _rmb := Input.is_action_pressed("rmb")
	
	var _power1 := Input.is_action_pressed("power_1")
	var _power2 := Input.is_action_pressed("power_2")
	
	var east := int(Input.is_action_pressed("move_right")) << 1
	var west := int(Input.is_action_pressed("move_left")) << 2
	var south := int(Input.is_action_pressed("move_down")) << 3
	var north := int(Input.is_action_pressed("move_up")) << 4
	
	var southeast := south + east
	var southwest := south + west
	var northeast := north + east
	var northwest := north + west
	
	var move_direction := east + west + south + north

	match move_direction:
		0:
			direction = Vector2()
			anim = "idle"
		east:
			direction.x += 1
			anim = "walk_east"
		west: 
			direction.x -= 1
			anim = "walk_west"
		south:
			direction.y += 1
			anim = "walk_south"
		southwest:
			direction.x -= 1
			direction.y += 1
			anim = "walk_southwest"
		southeast:
			direction.x += 1
			direction.y += 1
			anim = "walk_southeast"
		north:
			direction.y -= 1
			anim = "walk_north"
		northwest:
			direction.x -= 1
			direction.y -= 1
			anim = "walk_northwest"
		northeast:
			direction.x += 1
			direction.y -= 1
			anim = "walk_northeast"
	
	player_motion = direction.normalized() * SPEED * delta
	var _move = move_and_collide(player_motion)

	emit_signal('direction_changed',direction)

########## 4 Direction Orthogonal Movement w/ Grid Snapping ###########	
func battle_inputs(_delta: float) -> void:
	pass
