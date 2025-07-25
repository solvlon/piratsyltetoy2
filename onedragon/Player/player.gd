extends Node2D
class_name Player

@onready var controller = $PlayerController
@onready var weaponAttachementParent = $PlayerController/AnimatedSprite2D

@export var maxHealth = 100
@export var health = 100
@export var attackPauseTime = 0.2
@export var attackRecoveryTime = 1

var weaponAttachements = Array()
var weaponList = Array()
var _canAttack = true

func _ready() -> void:
	for attachement in weaponAttachementParent.get_children():
		weaponAttachements.append(attachement)

func _physics_process(delta: float) -> void:
	if _canAttack && Input.is_action_just_pressed("attack1"):
		attack()
	
func on_hit(hitpoints, force) -> void:
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

func equip(weapon) -> void:
	weapon.setup(controller, weaponAttachements[weaponList.size()])
	weaponList.append(weapon)

func attack() -> void:
	_canAttack = false
	for weapon in weaponList:
		weapon.attack()
		await get_tree().create_timer(attackPauseTime).timeout
	await get_tree().create_timer(attackRecoveryTime).timeout
	_canAttack = true
