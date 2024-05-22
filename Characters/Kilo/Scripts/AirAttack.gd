extends State

signal player_landed_during_air_attack


@export var reg_attack : Area2D

var is_air_attacking : bool = false

func _ready():
	reg_attack.connect("attack_landed", Callable(self, "_attack_landed"))


func on_enter():
	air_attack()
	
func state_process(delta):
	check_for_landing()


func air_attack():
	animator.air_attack()
	reg_attack.monitoring = true
	is_air_attacking = true


func check_for_landing():
	if character.is_on_floor() and not is_air_attacking:
		emit_signal("player_landed_during_air_attack")
		
func _attack_landed():
	#print("attacklanded")
	reg_attack.set_deferred("monitoring", false)

		
func exit():
	reg_attack.monitoring = false
	is_air_attacking = false

