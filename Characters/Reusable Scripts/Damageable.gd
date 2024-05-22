extends Node

class_name Damageable

@export var character : CharacterBody2D
@export var health : int

######################################
@export var enemy_state_machine : Node

@export var has_death_state : bool
@export var death_state : Node

@export var has_hit_state : bool
@export var hit_state : Node

@export var has_knockback_node : bool
@export var knockback : Node
#######################################

@export var has_apply_knockback_function : bool

@export var death_particles : PackedScene
@export var queue_free_timer : Timer


##link text object##

func _ready():
	queue_free_timer.connect("timeout", Callable(self, "_queue_free_timer"))


func hit(damage ,opponent, knockback_force):
	health -= damage
	SignalBus.emit_signal("health_changed_emit", character, damage)
	#print("health - ",health)
	check_for_hit()
	check_for_death()
	try_knockback(opponent, knockback_force)
	
func damage_text(damage):
	pass
	
func check_for_hit():
	if has_hit_state == true:
		enemy_state_machine.current_state.next_state = hit_state
	
func check_for_death():
	if health <= 0:
		if has_death_state == true:
			enemy_state_machine.current_state.next_state = death_state
		else:
			#character.movement_lock = true
			queue_free_timer.start()
			
			##spawn particles##
		
func _queue_free_timer():
	spawn_death_particles()
	character.queue_free()
	
func spawn_death_particles():
	var particle_instance = death_particles.instantiate()
	particle_instance.position = character.global_position
	particle_instance.scale = character.scale
	get_tree().current_scene.add_child(particle_instance)
	particle_instance.emitting = true
	

func try_knockback(opponent, knockback_force):
	if has_knockback_node == true:
		character.movement_lock = true  ##turns off in hit state
		knockback.apply_force_to_charcter(opponent, knockback_force)
