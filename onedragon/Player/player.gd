extends Node2D
class_name Player

@onready var controller = $PlayerController
@onready var weaponAttachementParentR = $PlayerController/AnimatedSprite2D/RAttachements
@onready var weaponAttachementParentL = $PlayerController/AnimatedSprite2D/LAttachements

@export var maxHealth = 100
@export var health = 100
@export var attackPauseTime = 0.2
@export var attackRecoveryTime = 1
@export var attackPower = 1
@export var maxRHandWeapons = 1
@export var maxLHandWeapons = 1

var weaponAttachementsR = Array()
var weaponAttachementsL = Array()
var weaponListR = Array()
var weaponListL = Array()
var _canAttackR = true
var _canAttackL = true

func _ready() -> void:
	for attachement in weaponAttachementParentR.get_children():
		weaponAttachementsR.append(attachement)
	for attachement in weaponAttachementParentL.get_children():
		weaponAttachementsL.append(attachement)

func _physics_process(delta: float) -> void:
	if health <= 0:
		return
	if _canAttackR && Input.is_action_just_pressed("attack1") && weaponListR.size() > 0:
		attackR()
	if _canAttackL && Input.is_action_just_pressed("attack2") && weaponListL.size() > 0:
		attackL()
	
func on_hit(hitpoints, force) -> void:
	Globals.play_sound("player_get_hit")
	health -= hitpoints
	controller.on_hit(force)

func heal(points) -> void:
	Globals.play_sound("heal")
	health = clamp(health + points, 0, maxHealth)

func up_max_health(v) -> void:
	Globals.play_sound("heal")
	maxHealth += v
	health += v

func up_dash_dist(v) -> void:
	Globals.play_sound("heal")
	controller.dashSpeed *= v
	print(controller.dashSpeed)

func up_dash_speed(v) -> void:
	Globals.play_sound("heal")
	controller.dashRecoveryTime *= v
	print(controller.dashRecoveryTime)

func up_attack(v) -> void:
	attackPower *= v
	Globals.play_sound("heal")
	print(attackPower)

func unequip(weapon, isRightHand) -> void:
	if isRightHand:
		weaponListR.erase(weapon)
		weaponAttachementParentR.remove_child(weapon)
		weapon.queue_free()
	else:
		weaponListL.erase(weapon)
		weaponAttachementParentL.remove_child(weapon)
		weapon.queue_free()

func equip(weapon, isRightHand) -> void:
	if isRightHand:
		_equip(weapon, weaponListR, maxRHandWeapons, weaponAttachementParentR, weaponAttachementsR)
	else:
		_equip(weapon, weaponListL, maxLHandWeapons, weaponAttachementParentL, weaponAttachementsL)

func _equip(weapon, list, max, attachementParent, attachementList) -> void:
	
	if list.size() == max:
		var w = list.pop_front()
		attachementParent.remove_child(w)
		w.queue_free()
	
	if attachementList.size() <= list.size():
		# spawn new weapon attachement
		var newNode = Node2D.new()
		attachementParent.add_child(newNode)
		newNode.global_position = attachementParent.global_position + randf_range(15, 15 + weaponListR.size()*2) * Vector2.from_angle(randf_range(0, 2*PI))
		attachementList.append(newNode)
	weapon.setup(controller, attachementList[list.size()])
	list.append(weapon)
	if weapon.playerAnimation != "":
		controller.animWeap = weapon.playerAnimation
	

func attackR() -> void:
	_canAttackR = false
	controller.play_attack()
	_attack(weaponListR)
	_canAttackR = true

func attackL() -> void:
	_canAttackL = false
	_attack(weaponListL)
	_canAttackL = true
	
func _attack(weaponList) -> void:
	for weapon in weaponList:
		weapon.attack(attackPower)
		await get_tree().create_timer(attackPauseTime).timeout
	await get_tree().create_timer(attackRecoveryTime).timeout
