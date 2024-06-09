extends Node

class_name Knockback

var taking_hit_knockback : int
var can_knockback : bool = true

@export var charcter : CharacterBody2D
@export var knockback_timer : Timer

func _ready():
	knockback_timer.connect("timeout", Callable(self, "_can_get_knockback"))

func grab_attack_direction_position(chosen_opponent):
	var opponent_position = chosen_opponent.global_position
	var attack_position = (charcter.global_position - opponent_position)#.normalized()
	return attack_position


func set_attack_direction(attack_direction):
	if attack_direction.x < 0:
		return -1
	elif attack_direction.x > 0:
		return 1
		
func apply_force_to_charcter(opponent, force):
	var attack_position = grab_attack_direction_position(opponent)
	var attack_direction = set_attack_direction(attack_position)
	#charcter.movement_lock = true 
	var knockback = attack_direction * force
	if can_knockback:
		if charcter.is_on_floor():
			charcter.velocity.x += knockback
			charcter.move_and_slide()
			can_knockback = false
			knockback_timer.start()
	#charcter.movement_lock = false 
		
func _can_get_knockback():
	can_knockback = true
##function that given direction and applies knockback##
