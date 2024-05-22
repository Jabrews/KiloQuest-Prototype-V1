extends Node

class_name StateMachine

@export var character : CharacterBody2D
@export var current_state : Node

#@export var animator : Node

var states : Array[State]

func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			
			# Set states up with what they need to function
			child.character = character
			
			
			##connect to intterupt 
			child.connect("interrupt_state", Callable(self, "_on_state_interrupt_state"))
			child.connect("change_animation", Callable(self, "_make_change_to_anim"))
			
		else:
			push_warning("Child", child.name , " is not valid state")

func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)

func check_if_can_move():
	return current_state.can_move
	
func switch_states(new_state : State):
	if current_state != null:
		current_state.exit()
		current_state.next_state = null
	current_state = new_state
	current_state.on_enter()

func _input(event : InputEvent):
	current_state.state_input(event)

func _on_state_interrupt_state(new_state : State):
	switch_states(new_state)
	
func _make_change_to_anim():
	pass
