extends Area2D

signal attack_landed

@export var damage : int
@export var charcter : CharacterBody2D

@export var knockback : Node
@export var knockback_force : int = 50
@export var sword_knockback_force : int = 100

func _ready():
	monitoring = false

func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			child.hit(damage, charcter, knockback_force)
			knockback.apply_force_to_charcter(body, knockback_force)
			emit_signal("attack_landed") ##might want to change how this triggers if making heavy enemies i can attack mutliple times
