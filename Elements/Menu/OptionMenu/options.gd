extends Control

@onready var exit_menu_button : Button = $MarginContainer/VBoxContainer/exit

signal exit_option_menu

func _ready():
	exit_menu_button.connect("button_down", Callable(self, "_on_exit_menu_button"))
	
func _on_exit_menu_button():
	emit_signal("exit_option_menu")
