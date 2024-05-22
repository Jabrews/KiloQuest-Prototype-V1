extends Label

@export var enemy_state_machine : Node


func _process(delta):
	text = "State " + enemy_state_machine.current_state.name
