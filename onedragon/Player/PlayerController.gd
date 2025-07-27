extends CharacterBody2D
class_name PlayerController

@export var moveSpeed = 150.0
@export var dashSpeed = 0.5
@export var dashSpeedMultiplier = 1.0
@export var dashRecoveryTime = 1.0
@export var pushRecovery = 10.0
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var hitParticleEffect = $Blood
@onready var dustParticleEffect = $Dust
@onready var player = $"../../Player"

var _canDash = true
var _animDir = "F"
var animWeap = ""
var _isAttacking = false

func _physics_process(delta: float) -> void:
	
	# on hit do nothing
	if animationPlayer.is_playing() && animationPlayer.current_animation == "Hit":
		velocity.x = move_toward(velocity.x, 0, pushRecovery)
		velocity.y = move_toward(velocity.y, 0, pushRecovery)
	else:
		manage_motion()

	move_and_slide()

func manage_motion() -> void:
	
	if _isAttacking:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)
		return
	
	if animationPlayer.is_playing() && animationPlayer.current_animation == "Dash":
		dash_move()
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0:
		_animDir = "R"
	elif direction.x < 0:
		_animDir = "L"
	if direction.y > 0:
		_animDir = "F"
	elif direction.y < 0:
		_animDir = "B"
	
	if direction:
		if _canDash && Input.is_action_just_pressed("dash"):
			dash()
			return
		# Moving
		animationPlayer.speed_scale = moveSpeed / 100
		animationPlayer.play("Run")
		sprite.play(str("Run", _animDir, animWeap))
		velocity = direction * moveSpeed
	else:
		# Not moving
		animationPlayer.speed_scale = 1
		animationPlayer.play("Idle")
		sprite.play(str("Idle", _animDir, animWeap))
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)

func dash() -> void:
	Globals.play_sound("dash")
	animationPlayer.play("Dash")
	_canDash = false
	dustParticleEffect.restart()
	await get_tree().create_timer(dashRecoveryTime).timeout
	_canDash = true

func play_attack() -> void:
	_isAttacking = true
	print(str("Attack", _animDir, animWeap))
	sprite.play(str("Attack", _animDir, animWeap))
	

func dash_move() -> void:
	velocity = velocity.normalized() * moveSpeed * dashSpeedMultiplier * dashSpeed

func on_hit(force: Vector2) -> void:
	animationPlayer.speed_scale = 1
	animationPlayer.play("Hit")
	hitParticleEffect.restart()
	hitParticleEffect.emitting = true
	velocity = force

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation.begins_with("Attack"):
		_isAttacking = false
