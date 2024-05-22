extends State

@export var hit_grace_timer : Timer
@export var ground_state : Node

func on_enter():
	hit_grace_timer.start()

func _on_hit_grace_timeout():
	print("leaving hit state")
	next_state = ground_state
