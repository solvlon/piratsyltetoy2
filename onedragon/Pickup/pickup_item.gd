extends Area2D

@export var action = "up_max_health"
@export var power = 10

func _on_body_entered(body):
	var f = Callable(body.get_parent(), action)
	f.call(power)
	queue_free()
