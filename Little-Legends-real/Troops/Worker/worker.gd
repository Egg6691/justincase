extends CharacterBody2D

@export var team: int = 1
@export var Speed: int = 6
@export var Health: int = 100
var food = 10
var mana = 0
var endPoint = Vector2(0,0)
var busy = false
func _process(delta):
	if Health <= 0:
		queue_free()
	if movementRangeValid():
		var direction = position.direction_to(endPoint)
		velocity = direction * Speed * 120
		move_and_slide()
	var allBodies = get_node("Attack Range").get_overlapping_bodies()
	for body in allBodies:
		if body.is_in_group("structure") and body.activated == false:
			body.activated = true
			queue_free()
func attackRangeValid():
	if get_node("Attack Range").has_overlapping_bodies():
		return true;
	return false;	
func moveTo(ep):
	endPoint = ep;
	if endPoint.x < position.x:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
func movementRangeValid():
	if position.x <= endPoint.x + 20 and position.x >= endPoint.x - 20:
		if position.y <= endPoint.y + 20 and position.y >= endPoint.y - 20:
			return false;
	return true;
