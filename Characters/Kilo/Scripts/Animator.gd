extends Node


signal finished_default_attack_anim
signal finished_poke_attack_anim

@export var StateRefrence : Node

@export var player_movement : CharacterBody2D
@export var main_anim : AnimatedSprite2D

var jumpLock : bool = false
var attackLock : bool = false

func _ready():
	main_anim.connect("animation_finished", Callable(self, "_on_anim_finished"))
	StateRefrence.floor_attack_state.connect("attack_interrupted", Callable(self, "_attack_interuptted"))
	StateRefrence.air_attack_state.connect("player_landed_during_air_attack", Callable(self, "_air_attack_interrupted"))

func _process(delta):
	flip_sprite()
	if jumpLock:
		if player_movement.is_on_floor() and main_anim.animation == "air":
			main_anim.play("jump_end")  # Transition to jump_end if landed
	elif not jumpLock and not attackLock:
		if player_movement.is_on_floor():
			if player_movement.direction == 0:
				main_anim.play("idle")
			elif player_movement.direction == 1 || -1:
				main_anim.play("run")
		elif !player_movement.is_on_floor():
			main_anim.play("air")
				
func flip_sprite():
	if player_movement.direction < 0:
		main_anim.flip_h = true
	elif player_movement.direction > 0:
		main_anim.flip_h = false


func start_jump():
	jumpLock = true  # Lock the animation when jump starts
	main_anim.play("jump_start")

func _on_anim_finished():
	# Check which animation finished
	if main_anim.animation == "jump_start":
		main_anim.play("air")  # Go to air after jump start
	elif main_anim.animation == "double_jump":
		main_anim.play("air")
	elif main_anim.animation == "jump_end":
		jumpLock = false  # Release the animation lock after jump end
	elif main_anim.animation == "attack1":
		StateRefrence.floor_attack_state.next_state = StateRefrence.ground_state
		attackLock = false
		main_anim.play("idle")
	elif main_anim.animation == "attack2":
		StateRefrence.floor_attack_state.next_state = StateRefrence.ground_state
		attackLock = false
		main_anim.play("idle")
	elif main_anim.animation == "air_attack":
		attackLock = false
		main_anim.play("air")
		StateRefrence.air_attack_state.is_air_attacking = false
		
func start_double_jump():
	jumpLock = true
	main_anim.play("double_jump")

func attack():
	attackLock = true 
	main_anim.play("attack1")
	
func secondary_attack():
	attackLock = true 
	main_anim.play("attack2")

func _attack_interuptted():
	main_anim.play("run")
	attackLock = false
	
func air_attack():
	attackLock = true
	main_anim.play("air_attack") 
	
func _air_attack_interrupted():
	StateRefrence.air_attack_state.next_state = StateRefrence.ground_state
	#main_anim.play("idle")
	attackLock = false
