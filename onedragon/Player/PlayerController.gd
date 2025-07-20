extends CharacterBody2D

const SPEED = 300.0
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction:
		# Moving
		animationPlayer.speed_scale = SPEED / 100
		animationPlayer.play("Run")
		velocity = direction * SPEED
	else:
		# Not moving
		animationPlayer.speed_scale = 1
		animationPlayer.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if direction.x < 0:
		sprite.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false

	move_and_slide()
