extends State

@export var attack_area : Area2D

@export var damage : int 
@export var damage_re_apply : Timer
var direction = null

@export var delay_after_attacking : Timer
@export var reset_hit_back_bounce_timer : Timer

var saved_body : CharacterBody2D = null

@export var knockback_force : int = 500


func _ready():
	reset_hit_back_bounce_timer.connect("timeout", Callable(self, "_reset_for_bounce_back"))

func on_enter():
	reset_hit_back_bounce_timer.start()

func _reset_for_bounce_back():
	character.hit_bounce_back = false

func _on_attack_body_entered(body):
	if body.is_in_group("player"):
		body.hit(damage)
		body.knockback.apply_force_to_charcter(character, knockback_force)
		#body.apply_force_to_charcter
		saved_body = body
		damage_re_apply.start()
		character.movement_lock = true ##change variable
		
		delay_after_attacking.start()
		
func exit():
	damage_re_apply.stop()
	saved_body = null
	direction = null

func _on_damage_reapply_timeout():
	saved_body.hit(damage)
	damage_re_apply.start()


func _on_attack_body_exited(body):
	damage_re_apply.stop()
	saved_body = null


func movement_lock():
	character.movement_lock = false


func _on_delay_after_attacking_timer_timeout():
	character.movement_lock = false ##change variable.
