extends Node

class_name State

signal interrupt_state(new_state)
signal change_animation(new_animation)

@export var character : CharacterBody2D
@export var animator : Node
@export var can_move : bool
@export var StateRefrence : Node
@export var knockback : Node

var next_state : Node = null

func state_process(delta):
	pass
	
func state_input(event : InputEvent):
	pass
	
func exit():
	pass
	
func on_enter():
	pass
