extends CharacterBody2D

class_name BaseTroop 
var FIREBALL: PackedScene = preload("res://Projectiles/Fireball/fireball.tscn")
var ARROW: PackedScene = preload("res://Projectiles/Arrow/arrow.tscn")
var troopType
var endReached = true
@export var Speed: int = 1
@export var Health: int = 100
var endPoint = Vector2(0,0)
@export var team: int = 1
@export var Damage: int = 10
@export var Ranged: bool = false
@export var attackSpeedWaitTime: float = .7
var attacking = false
@onready var attackSpeed= get_node("AttackSpeed")
@onready var animation= $AnimationPlayer
var is_barracks
var is_castle
var food = 0
var mana = 0

func _ready():
	is_barracks = false
	is_castle = false
	attackSpeed.wait_time = attackSpeedWaitTime
func _process(_delta):
	if Health <= 0:
		queue_free()
	if not attacking:
		if  movementRangeValid():
			var direction = position.direction_to(endPoint)
			velocity = direction * Speed * 100
			move_and_slide()
		if attackRangeValid() and attackSpeed.is_stopped():
			var allBodies = get_node("Attack Range").get_overlapping_bodies()
			for body in allBodies:
				if body.is_in_group("attackable") and body.Health > 0 and body.team != team:
					attackSpeed.start()
					attacking = true;
					faceEnemy(body)
					animation.play(troopType + "_Attacking")
					if Ranged:
						var projectile = ARROW.instantiate()
						if troopType == "Wizard":
							projectile = FIREBALL.instantiate()
						else:
							body.Health-=Damage;
						get_tree().current_scene.add_child(projectile)
						projectile.setEndPoint(body.position)
						projectile.setTeam(team)
						projectile.position = position
						var projectileRotation = position.direction_to(body.position).angle()
						projectile.rotation = projectileRotation
					else:
						body.Health-=Damage;
					break
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
func attackRangeValid():
	if get_node("Attack Range").has_overlapping_bodies():
		return true;
	return false;

func _on_attack_speed_timeout():
	attacking = false
	animation.stop()
	#stop anim
func faceEnemy(opps):
	if opps.position.x < position.x:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false


func _on_animation_player_animation_finished(anim_name):
	attacking = false
