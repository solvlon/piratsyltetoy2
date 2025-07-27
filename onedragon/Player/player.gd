extends Node2D
class_name Player

@onready var controller = $PlayerController
@onready var weaponAttachementParent = $PlayerController/AnimatedSprite2D

@export var maxHealth = 100
@export var health = 100
@export var attackPauseTime = 0.2
@export var attackRecoveryTime = 1

var weaponAttachements = Array()
var weaponListR = Array()
var weaponListL = Array()
var _canAttackR = true
var _canAttackL = true

func _ready() -> void:
	for attachement in weaponAttachementParent.get_children():
		weaponAttachements.append(attachement)

func _physics_process(delta: float) -> void:
	if _canAttackR && Input.is_action_just_pressed("attack1"):
		attackR()
	if _canAttackL && Input.is_action_just_pressed("attack2"):
		attackL()
	
func on_hit(hitpoints, force) -> void:
	Globals.play_sound("player_get_hit")
	health -= hitpoints
	controller.on_hit(force)

func heal(points) -> void:
	health = clamp(health + points, 0, maxHealth)

func up_max_health(v) -> void:
	maxHealth += v
	health += v

func up_dash_dist(v) -> void:
	controller.dashSpeedMultiplier *= v

func up_dash_speed(v) -> void:
	controller.dashRecoveryTime *= v

func equip(weapon, isRightHand) -> void:
	if isRightHand:
		_equip(weapon, weaponListR)
	else:
		_equip(weapon, weaponListL)

func _equip(weapon, list) -> void:
	if weaponAttachements.size() <= list.size():
		# spawn new weapon attachement
		var newNode = Node2D.new()
		weaponAttachementParent.add_child(newNode)
		newNode.global_position = weaponAttachementParent.global_position + randf_range(15, 15 + weaponListR.size()*2) * Vector2.from_angle(randf_range(0, 2*PI))
		weaponAttachements.append(newNode)
	weapon.setup(controller, weaponAttachements[list.size()])
	list.append(weapon)
	if weapon.playerAnimation != "":
		controller.animWeap = weapon.playerAnimation
	

func attackR() -> void:
	_canAttackR = false
	_attack(weaponListR)
	_canAttackR = true

func attackL() -> void:
	_canAttackL = false
	_attack(weaponListL)
	_canAttackL = true
	
func _attack(weaponList) -> void:
	for weapon in weaponList:
		weapon.attack()
		await get_tree().create_timer(attackPauseTime).timeout
	await get_tree().create_timer(attackRecoveryTime).timeout
