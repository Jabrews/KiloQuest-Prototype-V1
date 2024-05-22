extends CharacterBody2D

var seen : bool = false

@export var floor_ray : RayCast2D
@export var wall_ray : RayCast2D
@export var attack_hurtbox : Area2D
@export var wall_collide_timer : Timer
@export var speed : int
@export var knockback_distance : int

@export var gravity = 200

var moving_left : bool = true
var movement_lock : bool = false
var has_collided : bool = false
var hit_bounce_back : bool = false


func _ready():
	wall_collide_timer.connect("timeout", Callable(self, "_turn_around"))


func _physics_process(delta):
	if seen == true:
		if not movement_lock:
			movement()
			check_if_ray_colliding()
		
		if !is_on_floor():
			velocity.y += gravity



func check_if_ray_colliding():
	if wall_ray.is_colliding(): #and not has_collided:
		moving_left = !moving_left
		scale.x = -scale.x
		#has_collided = true
		#wall_collide_timer.start()
	if not floor_ray.is_colliding() and not hit_bounce_back:
		moving_left = !moving_left
		scale.x = -scale.x
		#print("floor ray collosion") ##get floor working correctly##

func _turn_around():
	moving_left = !moving_left
	scale.x = -scale.x
	has_collided = false

func movement():
	if moving_left == true:
		velocity.x = -speed
	elif moving_left == false:
		velocity.x = speed
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_entered():
	seen = true
