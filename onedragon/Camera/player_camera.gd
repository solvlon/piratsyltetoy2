extends Camera2D

@export var player :Player
@export var SPEED = 10

func _process(delta: float) -> void:
	position = lerp(position, player.controller.global_position, SPEED * delta)
