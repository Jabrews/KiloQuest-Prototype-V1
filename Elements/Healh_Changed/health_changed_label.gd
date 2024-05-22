extends Label

@export var disable_timer : Timer 

@export var float_speed : Vector2 = Vector2(0, -50)

func _ready():
	disable_timer.connect("timeout", Callable(self, "_disabel_timer_ended"))
	disable_timer.start()

func _process(delta):
	position += float_speed * delta
	
func _disabel_timer_ended():
	queue_free()
