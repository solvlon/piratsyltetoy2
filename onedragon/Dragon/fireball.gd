extends Area2D
class_name FireBall

@export var damages = 50
@export var force = 500
const SPEED = 300

var move_direction : Vector2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += move_direction*delta * SPEED

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_body_enter(body) -> void:
	body.player.on_hit(damages, move_direction * force)
	queue_free()
