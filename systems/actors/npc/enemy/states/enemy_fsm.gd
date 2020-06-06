extends StateMachine

func _ready() -> void:
	set_process(false)
	call_deferred("set_state", states.patrol)
	set_process(true)
	
	
func _process(_delta) -> void:
	var text 
	match state:
		states.attack:
			text = "attack"
		states.chase:
			text = "chase"
		states.idle:
			text = "idle"
		states.patrol:
			text = "patrol"
		_:
			text = "idle"
			
	get_node("../Label").set_text(text)

func _state_logic(delta: float):
	match state:
		states.attack:
			return $Attack._state_logic(delta)
		states.chase:
			return $Chase._state_logic(delta)
		states.idle:
			return $Idle._state_logic(delta)
		states.patrol:
			return $Patrol._state_logic(delta)
		_:
			return $Idle._state_logic(delta)
	
func _get_transition(delta: float):
	match state:
		states.attack:
			return $Attack._get_transition(delta)
		states.chase:
			return $Chase._get_transition(delta)
		states.idle:
			return $Idle._get_transition(delta)
		states.patrol:
			return $Patrol._get_transition(delta)
		_:
			return $Idle._get_transition(delta)
	
func _enter_state(new_state: int, old_state: int):
	match state:
		states.attack:
			return $Attack._enter_state(new_state, old_state)
		states.chase:
			return $Chase._enter_state(new_state, old_state)
		states.idle:
			return $Idle._enter_state(new_state, old_state)
		states.patrol:
			return $Patrol._enter_state(new_state, old_state)
		_:
			return $Idle._enter_state(new_state, old_state)

	
func _exit_state(old_state: int, new_state: int):
	match state:
		states.attack:
			return $Attack._exit_state(old_state, new_state)
		states.chase:
			return $Chase._exit_state(old_state, new_state)
		states.idle:
			return $Idle._exit_state(old_state, new_state)
		states.patrol:
			return $Patrol._exit_state(old_state, new_state)
		_:
			return $Idle._exit_state(old_state, new_state)
	
func set_state(new_state: int) -> void:
	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, previous_state)
