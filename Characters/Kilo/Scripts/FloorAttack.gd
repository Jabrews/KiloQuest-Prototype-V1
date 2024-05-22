extends State

class_name AttackState

signal attack_interrupted



@export var reg_attack : Area2D
@export var poke_attack : Area2D

@export var attack_duration_timer : Timer

var can_cancel : bool = true
var can_extra_hit : bool = false
var input_missed : bool = false

func _ready():
	attack_duration_timer.connect("timeout", Callable(self, "_no_longer_able_to_cancel"))
	reg_attack.connect("attack_landed", Callable(self, "_attack_landed"))
	#main_anim.connect("animation_finished", Callable(self, "_on_anim_finished"))

func on_enter():
	primary_attack()
	
func state_input(event : InputEvent):
	if event.is_action_pressed("attack") and can_extra_hit and not input_missed:
		secondary_attack()
	elif event.is_action_pressed("attack") and not can_extra_hit:
		pass
		#input_missed = true
	elif event.is_action_pressed("left") or event.is_action_pressed("right"):
		if can_cancel:
			emit_signal("attack_interrupted")
			next_state = StateRefrence.ground_state

func primary_attack():
	attack_duration_timer.start()
	#main_anim.play("attack1")
	animator.attack()
	
func secondary_attack():
	animator.secondary_attack()	
	reg_attack.monitoring = false
	poke_attack.monitoring = true
	can_extra_hit = false

func _no_longer_able_to_cancel():
	can_cancel = false
	can_extra_hit = true
	reg_attack.monitoring = true
		
func _attack_landed():
	can_extra_hit = false
		
		
func exit():
	attack_duration_timer.stop()
	can_cancel = true
	can_extra_hit = false
	input_missed = false
	reg_attack.monitoring = false
	poke_attack.monitoring = false
