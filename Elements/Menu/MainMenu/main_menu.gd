extends Control

@onready var start_game_button : Button = $MarginContainer/VBoxContainer/start_game
@onready var load_level_button : Button = $MarginContainer/VBoxContainer/load_level
@onready var options_button : Button = $MarginContainer/VBoxContainer/options

@export var first_level : PackedScene

@onready var option_menu : Control = $Options
@onready var margin_container : MarginContainer = $MarginContainer

func button_signal():
	start_game_button.connect("button_down", Callable(self, "_on_start_game_button"))
	load_level_button.connect("button_down", Callable(self, "_on_level_button"))
	options_button.connect("button_down", Callable(self, "_on_options_button"))
	
	option_menu.connect("exit_option_menu", Callable(self, "_leave_option_menu"))

func _ready():
	button_signal()


func _on_start_game_button():
	get_tree().change_scene_to_packed(first_level)
	
func _on_level_button():
	pass
	
func _on_options_button():
	option_menu.visible = true
	margin_container.visible = false

func _leave_option_menu():
	option_menu.visible = false
	margin_container.visible = true 
