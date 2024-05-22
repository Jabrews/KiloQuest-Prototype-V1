extends State

@export var return_from_hit_state_timer : Timer
@export var idle_state : Node

func on_enter():
	character.hit_bounce_back = true
	apply_up_velocity()
	animator.hit()
	return_from_hit_state_timer.start()


func _on_return_from_hit_state_timer_timeout():
	character.movement_lock = false
	next_state = idle_state


func apply_up_velocity():
	character.velocity.y += -100
