extends CharacterBody2D

var health : int  = 100
var can_get_hit : bool = true
var can_delay : bool = true

@export var speed : float = 300.0
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float =  ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var charcter_state_machine : Node

@export var can_get_hit_timer : Timer
@export var dash_cooldown_timer : Timer
@export var blink_interval_timer : Timer

@export var reg_attack : Area2D
@export var poke_attack : Area2D
@export var hitbox : CollisionShape2D
@export var hit_knockback_force : int 

var wanted_direction : int = 0
var direction : int = 0
var last_direction : int = 1  # Default direction, assuming character starts facing right
var is_dashing : bool = false
var can_dash : bool = true
var movement_lock : bool = false

@export var knockback : Node
@export var animated_sprite : AnimatedSprite2D

func _ready():
	dash_cooldown_timer.connect("timeout", Callable(self, "_dash_cooldown_ended"))
	can_get_hit_timer.connect("timeout", Callable(self, "_invincible_cooldown_ended"))
	blink_interval_timer.connect("timeout", Callable(self, "_player_sprite_blink_effect"))

func _physics_process(delta):
	apply_gravity(delta)
	
	animated_sprite.modulate.v = lerp(animated_sprite.modulate.v, 1.0, 1.0 * delta)

	
	## Player X Axis Movement ##
	if charcter_state_machine.check_if_can_move() and not movement_lock:
		direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		move_and_slide()
		
		##get last direction for knockback##
		if direction != last_direction and direction != 0:
			flip_hurtboxes() ####################################
			last_direction = direction

func get_gravity() -> float:
	if velocity.y < 0.0: ##if player is going up then use greatly reduced gravity
		return jump_gravity 
	else: 
		return fall_gravity

func apply_gravity(delta):
	if not is_on_floor() and not is_dashing:
		velocity.y += get_gravity() * delta

func _dash_cooldown_ended():
	can_dash = true ##after dash cooldown ends you can dash again

func flip_hurtboxes():
	reg_attack.scale.x = -reg_attack.scale.x
	poke_attack.scale.x = -poke_attack.scale.x
	hitbox.position.x = -hitbox.position.x
	
func hit(damage):
	if can_get_hit == true:
		print("player took ", damage, " damage")
		health -= damage
		can_get_hit = false
		can_get_hit_timer.start()
		set_collision_layer_value(1 , false)
		SignalBus.emit_signal("health_changed_emit", self, damage)
		hit_blink()
		#disable collosion mask
		check_for_death()
	
func check_for_death():
	if health <= 0:
		self.queue_free()
	
func _invincible_cooldown_ended():
	set_collision_layer_value(1 , true)
	blink_interval_timer.stop()
	can_get_hit = true

func hit_blink():
	blink_interval_timer.start()
	
func _player_sprite_blink_effect():
	animated_sprite.modulate.v = 0
