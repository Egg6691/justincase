extends Sprite2D
var endPoint
var endReached
@export var Speed = 5
var team

# Called when the node enters the scene tree for the first time.
func _ready():
	endReached = false
	pass # Replace with function body.

func setEndPoint(ep):
	endPoint = ep
func setTeam(teamVal):
	team = teamVal
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if endPoint != null:
		if not endReached and movementRangeValid():
			var direction = position.direction_to(endPoint).normalized()
			position += direction * Speed;
		if not movementRangeValid():
			endReached = true;
		if endReached:
			queue_free()
func movementRangeValid():
	if position.x <= endPoint.x + Speed and position.x >= endPoint.x - Speed:
		if position.y <= endPoint.y + Speed and position.y >= endPoint.y - Speed:
			return false;
	return true;
