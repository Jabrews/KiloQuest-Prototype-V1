extends AnimatedSprite2D

@export var order_number : int = 1
@export var player_health_manager : Node2D
@onready var rotation_interval_timer = $RotationIntervalTimer


var has_flashed : bool = false
var rotate_ready : bool = true

func _ready():
	rotation_interval_timer.connect("timeout", Callable(self, "_pulse_heart"))

func _process(delta):
	if player_health_manager.player_health < order_number:
		play("un_active")
		if not has_flashed:
			rotate_heart()
		elif has_flashed && rotate_ready:
			rotation_interval_timer.start()
			rotate_ready = false
	elif player_health_manager.player_health > order_number:
		play("active")

func rotate_heart():
	has_flashed = true
	scale = Vector2(1.5, 1.5)
	rotation_degrees = randf_range(-5, 5)
	
func _pulse_heart():
	rotation_degrees = randf_range(-10, 10)
	rotate_ready = true
	
func _physics_process(delta):
	scale = lerp(scale, Vector2(1,1), 6 * delta)
	rotation_degrees = lerp(rotation_degrees, 0.0, 6 * delta)
	
