extends Sprite2D
 
func _ready():
	ghosting()
 
func set_property(tx_pos, tx_scale, flip):
	position = tx_pos
	scale = Vector2(1.2, 1.2)
	if flip:
		flip_h = true
	else:
		flip_h = false
 
func ghosting():
	var tween_fade = create_tween()
 
	tween_fade.tween_property(self, "self_modulate",Color(1, 1, 1, 0), .75 ) #.75
	await tween_fade.finished
 
	queue_free()
 
