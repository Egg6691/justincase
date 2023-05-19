extends structure

@onready var timer = get_node("Timer")
@export var timer_activated = false
func _ready():
	Health = 100
	size = Vector2(31,31)
	stone = 50
	wood = 50

func _process(delta):
	if activated and timer_activated == false:
		timer_activated = true
		timer.start()


func _on_timer_timeout():
	get_parent()._food(-10)
	timer.start()
