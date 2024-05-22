extends CharacterBody2D

@export var damage : int = 25
@export var speed : int = 50
@export var x_sin_value : float = .10


@export var move_right : bool = false

var seen : bool = false

func _ready():
	if move_right == true:
		velocity.x = 1
	else:
		velocity.x = -1

func _physics_process(delta):
	if seen == true:
		velocity.y = sin(global_position.x * 0.10)
		global_position += velocity * speed * delta
	


func _on_attack_body_entered(body):
	if body.is_in_group("player"):
		body.hit(damage)


func _on_visible_on_screen_notifier_2d_screen_entered():
	seen = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
