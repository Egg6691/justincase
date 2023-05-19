extends Area2D
var task = "Nothing"
var current_building
var current_building_node
var overlapping = 0
var current_body
var x1
var y1
var selected = []
var camLimits = [-442,448,-705,705]#0 = left; 1= right; 2 = top; 3 = bottom;
@onready var square_coll = get_node("Select_Collision")
@onready var square_size = get_node("Select_Square")
@onready var castle_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Buildings/VBoxContainer/Castle")
@onready var sawmill_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Buildings/VBoxContainer2/Sawmill")
@onready var mines_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Buildings/VBoxContainer3/Mines")
@onready var barracks_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Buildings/VBoxContainer4/Barracks")
@onready var farm_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Buildings/VBoxContainer5/Farm")
@onready var wall_v_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Buildings/VBoxContainer6/Wall_V")
@onready var wall_h_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Buildings/VBoxContainer7/Wall_H")
@onready var Camera = get_tree().root.get_child(0).get_node("Camera2D")

@onready var worker_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Unit_Clicked/VBoxContainer/Worker")
@onready var soldier_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Unit_Clicked/VBoxContainer2/Soldier")
@onready var archer_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Unit_Clicked/VBoxContainer3/Archer")
@onready var wizard_button = get_tree().root.get_child(0).get_node("Camera2D/CanvasLayer/UI/VBoxContainer/MainStuff/Unit_Clicked/VBoxContainer4/Wizard")
var mouse_position
func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position + Camera.position - get_viewport_rect().size/2
		if task == "DragCam":
			if not (Camera.position.x < camLimits[0] or Camera.position.x > camLimits[1] or Camera.position.y < camLimits[2] or Camera.position.y > camLimits[3]):
				Camera.position -= event.relative
			if Camera.position.x < camLimits[0]:
				Camera.position = Vector2(camLimits[0],Camera.position.y)
			if Camera.position.x > camLimits[1]:
				Camera.position = Vector2(camLimits[1],Camera.position.y)
			if Camera.position.y < camLimits[2]:
				Camera.position = Vector2(Camera.position.x,camLimits[2])
			if Camera.position.y > camLimits[3]:
				Camera.position = Vector2(Camera.position.x,camLimits[3])
		else:
			var tiles = Vector2(int(mouse_position.x) / 16, int(mouse_position.y) / 16)
			if x1 != null and y1 != null:
				var shape = RectangleShape2D.new()
				shape.size = Vector2(abs(mouse_position.x-x1),abs(mouse_position.y -y1) )
				square_coll.set_shape(shape)
				square_size.scale = shape.size
				square_coll.position = Vector2(mouse_position.x-x1,mouse_position.y -y1)/2
				square_size.position = Vector2(mouse_position.x-x1,mouse_position.y -y1)/2
			else:
				position = tiles * 16
	if event.is_action_pressed("mouse1", false) and position.y <= 156:
		if get_parent().get_node("Camera2D/CanvasLayer/UI").get_node("VBoxContainer/MainStuff/Unit_Clicked").visible == true:
			get_parent().get_node("Camera2D/CanvasLayer/UI").get_node("VBoxContainer/MainStuff/Unit_Clicked").visible = false
			get_parent().get_node("Camera2D/CanvasLayer/UI").get_node("VBoxContainer/MainStuff/Buildings").visible = true
		if current_building != null and overlapping == 0 and check_resources(current_building_node):
			var new_building = current_building.instantiate()
			new_building.position = position
			get_parent().add_child(new_building)
			if current_building_node.is_castle == true:
				get_parent().castles+= 1	
		if overlapping >= 1 and current_body.is_barracks:
			var shape = RectangleShape2D.new()
			shape.size = Vector2(1,1)
			square_coll.set_shape(shape)
			square_size.scale = shape.size
			current_building = null
			current_building_node = null
			get_parent().get_node("Camera2D/CanvasLayer/UI").get_node("VBoxContainer/MainStuff/Unit_Clicked").visible = true
			get_parent().get_node("Camera2D/CanvasLayer/UI").get_node("VBoxContainer/MainStuff/Buildings").visible = false
		else:
			task = "SelectionStuff" # dont worry brandon you dont need it I just wanted it
			x1 = mouse_position.x
			y1 = mouse_position.y
	if event.is_action_released("mouse1"):
		x1 = null
		y1 = null
		var shape = RectangleShape2D.new()
		shape.size = Vector2(1,1)
		square_coll.set_shape(shape)
		square_size.scale = shape.size
		current_building = null
		current_building_node = null
		square_coll.position = Vector2(0,0)
		square_size.position = Vector2(0,0)
		selected = get_overlapping_bodies()
		
	if event.is_action_pressed("mouse3", false):
		task = "DragCam"
	if event.is_action_released("mouse3"):
		task = "Nothing"
	if event.is_action_pressed("mouse2"):
		var shape = RectangleShape2D.new()
		shape.size = Vector2(1,1)
		square_coll.set_shape(shape)
		square_size.scale = shape.size
		current_building = null
		current_building_node = null
		for i in selected:
			if i != null and i.is_in_group("troop"):
				i.moveTo(mouse_position)

func _ready():
	castle_button.pressed.connect(_on_castle_pressed)
	mines_button.pressed.connect(_on_mines_pressed)
	sawmill_button.pressed.connect(_on_sawmill_pressed)
	barracks_button.pressed.connect(_on_barracks_pressed)
	wall_h_button.pressed.connect(_on_wall_pressed)	
	wall_v_button.pressed.connect(_on_wall_v_pressed)	
	farm_button.pressed.connect(_on_farm_pressed)
	soldier_button.pressed.connect(_on_soldier_pressed)
	archer_button.pressed.connect(_on_archer_pressed)
	wizard_button.pressed.connect(_on_wizard_pressed)
	worker_button.pressed.connect(_on_worker_pressed)
func check_resources(building):
	if get_parent().wood >= building.wood and get_parent().stone >= building.stone: 
		_remove_resources(building.wood, building.stone, 0, 0)
		return true
	return false
func check_food(soldier):
	if get_parent().food >= soldier.food and get_parent().mana >= soldier.mana:
		_remove_resources(0,0, soldier.food, soldier.mana)
		return true
	return false
func _remove_resources(wood, stone, food, mana):
	var parent = get_parent()
	parent._wood(wood)
	parent._stone(stone)
	parent._food(food)
	parent._mana(mana)
func _on_soldier_pressed():
	var soldier = load("res://Troops/Soldier/soldier.tscn")
	var new = soldier.instantiate()
	if check_food(new):

		for i in get_tree().root.get_child(0).get_children():
			if i.is_in_group("barracks"):	
				new.position = i.position+Vector2(0,32)	
				break	
		get_tree().root.get_child(0).add_child(new)
		new.moveTo(new.position+Vector2(0, 64))
func _on_wizard_pressed():
	var soldier = load("res://Troops/Wizard/wizard.tscn")
	var new = soldier.instantiate()
	if check_food(new):
		for i in get_tree().root.get_child(0).get_children():
			if i.is_in_group("barracks"):	
				new.position = i.position+Vector2(0,32)	
				break	
		get_tree().root.get_child(0).add_child(new)
		new.moveTo(new.position+Vector2(0, 64))
func _on_archer_pressed():
	var soldier = load("res://Troops/Archer/archer.tscn")
	var new = soldier.instantiate()
	if check_food(new):
		for i in get_tree().root.get_child(0).get_children():
			if i.is_in_group("barracks"):	
				new.position = i.position+Vector2(0,32)	
				break	
		get_tree().root.get_child(0).add_child(new)
		new.moveTo(new.position+Vector2(0, 64))
func _on_worker_pressed():
	var soldier = load("res://Troops/Worker/worker.tscn")
	var new = soldier.instantiate()
	if check_food(new):
		for i in get_tree().root.get_child(0).get_children():
			if i.is_in_group("barracks"):	
				new.position = i.position+Vector2(0,32)	
				break	
		get_tree().root.get_child(0).add_child(new)
		new.moveTo(new.position+Vector2(0, 64))	
func _on_castle_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Castle"), load("res://Structures/Castle/castle.tscn"))
func _on_sawmill_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Sawmill"), load("res://Structures/Sawmill/sawmill.tscn"))
func _on_mines_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Mines"), load("res://Structures/Mines/mines.tscn"))
func _on_barracks_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Barracks"), load("res://Structures/Barracks/barracks.tscn"))
func _on_wall_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Wall_H"), load("res://Structures/Wall_H/wall_h.tscn"))
func _on_wall_v_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Wall_V"), load("res://Structures/Wall_V/wall_v.tscn"))
func _on_turret_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Turret"), load("res://Structures/Turret/turret.tscn"))
func _on_farm_pressed():
	_button_pressed(get_parent().get_node("CanvasLayer/Farm"), load("res://Structures/Farm/farm.tscn"))

func _button_pressed(node, scene):
	var shape = RectangleShape2D.new()
	shape.size = node.size
	square_coll.set_shape(shape)
	square_size.scale = shape.size
	current_building_node = node;
	current_building = scene
func _on_body_entered(body):
	current_body = body
	overlapping += 1
func _on_body_exited(body):
	overlapping -= 1
