extends State

class_name DashState

@export var ghost_node : PackedScene

@export var dash_force: float 

@export var dash_distance_timer : Timer
@export var dash_cooldown_timer : Timer
@export var ghost_timer : Timer

@export var dash_particles : PackedScene
var dash_particles_instancne

var impulse 
var saved_direction : int = 0 #0
var dash_end = false
var can_dash = true
var flip = false


func _ready():
	dash_distance_timer.connect("timeout", Callable(self, "_on_dash_distance_timer_timeout"))
	ghost_timer.connect("timeout", Callable(self, "_on_ghost_timer_timeout"))

func state_process(delta):
	#emit_dash_particles()
	dash(delta)
	check_for_interrupts()

func on_enter():
	character.set_collision_layer_value(1 , false)
	saved_direction = character.direction
	dash_distance_timer.start()
	ghost_timer.start()

func check_for_interrupts():
	# Check if the character hit a wall
	if character.is_on_wall():
		emit_signal("interrupt_state", StateRefrence.ground_state)
		return 

	if character.direction != saved_direction:
		emit_signal("interrupt_state", StateRefrence.ground_state)
		return 

func dash(delta):
	if saved_direction != 0:
		var fixed_impulse_x = dash_force * saved_direction  
		var impulse =  Vector2(fixed_impulse_x, 0) 
		character.is_dashing = true
		apply_velocity_change(impulse)
	else: 
		next_state = StateRefrence.air_state

func add_ghost():
	var ghost_instance = ghost_node.instantiate()
	if character.direction < 0: ##check if charcter is facing other direction
		flip = true
	ghost_instance.set_property(character.position, character.scale, flip)
	get_tree().current_scene.add_child(ghost_instance)

func _on_ghost_timer_timeout():
	add_ghost()


func apply_velocity_change(impulse: Vector2):
	if dash_end == false:
		character.velocity.y = 0
		character.velocity += impulse
		character.move_and_slide()
	else:
		next_state = StateRefrence.air_state
		


func exit():
	character.set_collision_layer_value(1 , true)
	saved_direction = 0
	character.is_dashing = false
	dash_end = false
	dash_distance_timer.stop()
	ghost_timer.stop()
	character.can_dash = false
	dash_cooldown_timer.start()
	flip = false
	
	
func _on_dash_distance_timer_timeout():
	next_state = StateRefrence.air_state


func emit_dash_particles():
	dash_particles_instancne = dash_particles.instantiate()
	dash_particles_instancne.position = character.global_position
	dash_particles_instancne.scale = character.scale
	get_parent().add_child(dash_particles_instancne)
	dash_particles_instancne.emitting = true
	
