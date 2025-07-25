extends CharacterBody2D
class_name PlayerController

@export var moveSpeed = 300.0
@export var dashSpeedMultiplier = 1.0
@export var dashRecoveryTime = 1.0
@export var pushRecovery = 10.0
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var hitParticleEffect = $Blood
@onready var dustParticleEffect = $Dust
@onready var player = $"../../Player"

var _canDash = true
var _animDir = "_F"

func _physics_process(delta: float) -> void:
	
	# on hit do nothing
	if animationPlayer.is_playing() && animationPlayer.current_animation == "Hit":
		velocity.x = move_toward(velocity.x, 0, pushRecovery)
		velocity.y = move_toward(velocity.y, 0, pushRecovery)
	else:
		manage_motion()

	move_and_slide()

func manage_motion() -> void:
	
	if animationPlayer.is_playing() && animationPlayer.current_animation == "Dash":
		dash_move()
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.x > 0:
		_animDir = "_R"
	elif direction.x < 0:
		_animDir = "_L"
	if direction.y > 0:
		_animDir = "_F"
	elif direction.y < 0:
		_animDir = "_B"
	
	if direction:
		if _canDash && Input.is_action_just_pressed("dash"):
			dash()
			return
		# Moving
		animationPlayer.speed_scale = moveSpeed / 100
		animationPlayer.play("Run")
		sprite.play(str("Run", _animDir))
		velocity = direction * moveSpeed
	else:
		# Not moving
		animationPlayer.speed_scale = 1
		animationPlayer.play("Idle")
		sprite.play(str("Idle", _animDir))
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)

func dash() -> void:
	Globals.play_sound("dash")
	animationPlayer.play("Dash")
	_canDash = false
	dustParticleEffect.restart()
	await get_tree().create_timer(dashRecoveryTime).timeout
	_canDash = true

func dash_move() -> void:
	velocity = velocity.normalized() * moveSpeed * dashSpeedMultiplier

func on_hit(force: Vector2) -> void:
	animationPlayer.speed_scale = 1
	animationPlayer.play("Hit")
	hitParticleEffect.restart()
	hitParticleEffect.emitting = true
	velocity = force
