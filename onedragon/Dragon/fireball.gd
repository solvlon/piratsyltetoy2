extends Area2D
class_name FireBall

const SPEED = 300

var move_direction : Vector2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += move_direction*delta * SPEED


func _on_despawn_timer_timeout() -> void:
	queue_free()
