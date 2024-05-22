extends Node2D

var player_health : int = 4

func _ready():
	SignalBus.connect("health_changed_emit", Callable(self, "_health_changed"))

func _process(delta):
	pass
	
func _health_changed(object, damage):
	if object.is_in_group("player"):
		if damage > 0:
			player_health -= 1
	
