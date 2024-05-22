extends Node

class_name RatAnimator

var animation_lock : bool = false

@export var animated_sprite_2d : AnimatedSprite2D 
@export var return_from_hit_state_timer : Timer

func _ready():
	return_from_hit_state_timer.connect("timeout", Callable(self, "_leaving_hit_state"))

func _process(delta):
	if not animation_lock:
		animated_sprite_2d.play("walk")
	else:
		pass


func hit():
	animation_lock = true
	animated_sprite_2d.play("hit")
	
func _leaving_hit_state():
	animation_lock = false
