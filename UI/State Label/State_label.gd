extends Label

@export var player_state_machine : Node

func _process(delta):
	pass
	text = "State " + player_state_machine.current_state.name
	
	
	
