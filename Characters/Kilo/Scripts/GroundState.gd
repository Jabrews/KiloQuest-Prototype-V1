extends State

class_name GroundState


@export var jump_start_timer : Timer

var direction : int = 0 
var can_dash : bool = true

func _ready():
	jump_start_timer.connect("timeout", Callable(self, "_jump_delay_ended"))

func on_enter():
	StateRefrence.air_state.can_double_jump = true
	StateRefrence.dash_state.can_dash = true

func state_process(delta):
	if !character.is_on_floor():
		next_state = StateRefrence.air_state

func state_input(event : InputEvent):
	if event.is_action_pressed("up"):
		animator.start_jump()
		jump_start_timer.start()
	elif event.is_action_pressed("attack"):
		attack()
	elif event.is_action_pressed("dash") and character.can_dash == true:
		dash()
	
	
func jump():
	animator.start_jump()
	jump_start_timer.start()
	
func attack():
	next_state = StateRefrence.floor_attack_state

func dash():
	next_state = StateRefrence.dash_state
		
func _jump_delay_ended():
	character.velocity.y += character.jump_velocity

