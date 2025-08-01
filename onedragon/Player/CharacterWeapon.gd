extends Node2D

@export var player: CharacterBody2D
@export var attach: Node2D

@export var POWER = 10
@export var FOLLOW_SPEED = 40
@export var ATTACK_SPEED = 0.5
@export var ATTACK_SPEED_TRAVEL = 5
@export var ATTACK_BACK_SPEED_TRAVEL = 20
@export var ATTACK_BACK_SPEED = 0.5
@export var ATTACK_DIST = 200
@export var FOLLOW_VEL_OFFSET = 0.02
@export var isRightHand = true
@export var playerAnimation = ""
@export var keepSpriteOnEquip = true
@export var usageCount = -1

@onready var animation = $AnimationPlayer
@onready var hitParticle = $HitParticle
@onready var equipArea = $EquipArea
@onready var hitArea = $HitArea
@onready var sprite = $WeaponSprite

var _isAttacking = false
var _isGoingBack = false
var _attackDir
var multiplier = 1

func setup(player: CharacterBody2D, attach: Node2D) -> void:
	self.player = player
	self.attach = attach

func _process(delta: float) -> void:
	if attach == null && player == null:
		return
	
	if _isAttacking:
		global_position = lerp(global_position, 
			attach.global_position + _attackDir , ATTACK_SPEED_TRAVEL * delta)
	else:
		var speed = ATTACK_BACK_SPEED_TRAVEL if _isGoingBack else FOLLOW_SPEED
		global_position = lerp(global_position, 
			attach.global_position + player.velocity * FOLLOW_VEL_OFFSET, speed * delta)

func attack(multiplier) -> void:
	if _isAttacking:
		return
	self.multiplier = multiplier
	
	hitArea.set_deferred("monitoring", true)
	# start attack
	animation.play("Attack")
	Globals.play_sound("throw")
	_isAttacking = true
	_attackDir = (get_global_mouse_position() - global_position).normalized() * ATTACK_DIST
	await get_tree().create_timer(ATTACK_SPEED).timeout
	
	# going back
	_isAttacking = false

	hitArea.set_deferred("monitoring", false)

	animation.play("Idle")
	_isGoingBack = true
	await get_tree().create_timer(ATTACK_BACK_SPEED).timeout
	_isGoingBack = false

func _on_touch(body) -> void:
	Globals.play_sound("crushed")
	hitParticle.restart()
	hitParticle.emitting = true
	body.on_hit(POWER * multiplier, Vector2.ZERO)
	usageCount = usageCount - 1
	if usageCount == 0:
		player.player.unequip(self, isRightHand)

func _on_equip_area_body_entered(body: Node2D) -> void:
	# body is player
	sprite.visible = keepSpriteOnEquip
	body.player.equip(self, isRightHand)

	Globals.play_sound("weapon_equip")
	equipArea.set_deferred("monitoring", false)
