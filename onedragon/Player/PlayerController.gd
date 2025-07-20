extends CharacterBody2D

@export var moveSpeed = 300.0
@export var pushRecovery = 10.0
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitParticleEffect = $Blood

func _physics_process(delta: float) -> void:
	
	# on hit do nothing
	if animationPlayer.is_playing() && animationPlayer.current_animation == "Hit":
		velocity.x = move_toward(velocity.x, 0, pushRecovery)
		velocity.y = move_toward(velocity.y, 0, pushRecovery)
	else:
		if Input.is_action_pressed("Attack1"):
			on_hit(Vector2(500, -500))
		else:
			manage_motion()

	move_and_slide()

func manage_motion() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		# Moving
		animationPlayer.speed_scale = moveSpeed / 100
		animationPlayer.play("Run")
		velocity = direction * moveSpeed
	else:
		# Not moving
		animationPlayer.speed_scale = 1
		animationPlayer.play("Idle")
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)

	# manage facing direction
	if direction.x < 0:
		sprite.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false


func on_hit(force: Vector2) -> void:
	animationPlayer.speed_scale = 1
	animationPlayer.play("Hit")
	hitParticleEffect.restart()
	hitParticleEffect.emitting = true
	
	velocity = force
	
