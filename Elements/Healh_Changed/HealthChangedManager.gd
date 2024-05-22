extends Node

class_name HealthChangedManager

@export var health_changed_label : PackedScene 
var damage_color = Color.DARK_RED
var heal_color = Color.DARK_GREEN

func _ready():
	SignalBus.connect("health_changed_emit", Callable(self, "_on_signal_health_changed"))
	
	
func _on_signal_health_changed(object : Node, amount_changed : int):
	var label_instance = health_changed_label.instantiate()
	if object.is_in_group("player"):
		label_instance.scale = Vector2(100, 100)
	object.add_child(label_instance)
	
	label_instance.text = str(amount_changed)
	
	if amount_changed >= 0:
		label_instance.modulate = heal_color
	else:
		label_instance.modulate = damage_color
		
