extends State

class_name AirState


@export var double_jump_duration_timer : Timer
@export var double_jump_particles : PackedScene

var can_double_jump = false

func _ready():
	double_jump_duration_timer.connect("timeout", Callable(self, "_double_jump_ready"))

func state_process(delta):
	if character.is_on_floor():
		next_state = StateRefrence.ground_state
		
func state_input(event : InputEvent):
	if event.is_action_pressed("dash") and character.can_dash == true:
		dash()
	elif event.is_action_pressed("up") and can_double_jump == true:
		double_jump_duration_timer.start()
	elif event.is_action_pressed("attack"):
		air_attack()
	
func dash(): 
	pass
	next_state = StateRefrence.dash_state
	
func air_attack():
	next_state = StateRefrence.air_attack_state	

func double_jump():
	animator.start_double_jump()
	character.velocity.y = 0
	character.velocity.y += character.jump_velocity
	spawn_double_jump_particles()
	can_double_jump = false
	
func _double_jump_ready():
	double_jump()
		
		
func spawn_double_jump_particles():
	var double_jump_particle_instance = double_jump_particles.instantiate()
	double_jump_particle_instance.position = character.global_position
	double_jump_particle_instance.scale = character.scale
	#double_jump_particle_instance.position.y += 

	get_tree().current_scene.add_child(double_jump_particle_instance)
	double_jump_particle_instance.emitting = true

