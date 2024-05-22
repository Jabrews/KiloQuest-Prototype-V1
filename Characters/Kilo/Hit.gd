extends State

class_name  HitState
	
@export var ground_state : Node
@export var air_state : Node
@export var hitstate_end_timer : Timer

func on_enter():
	hitstate_end_timer.start()
	
func state_input(event : InputEvent):
	if event.is_action_pressed("up") and character.is_on_floor():
		animator.start_jump()
		character.velocity.y += character.jump_velocity 
	
	
func _on_hit_state_timer_timeout():
	return_player_to_correct_state()
	


func return_player_to_correct_state():
	if character.is_on_floor():
		next_state = ground_state
	elif !character.is_on_floor():
		next_state = air_state
