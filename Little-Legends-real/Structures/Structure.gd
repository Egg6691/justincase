extends StaticBody2D
class_name structure

var team = 1
var Health = 1
var size = Vector2(63, 63)
var stone = 50
var wood = 50
var activated = false
var is_castle = false
var is_barracks = false
func _process(delta):
	if Health <= 0:
		if is_castle:
			get_parent().castles -= 1
		queue_free()
