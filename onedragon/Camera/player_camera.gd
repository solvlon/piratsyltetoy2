extends Camera2D

@export var player :Player
@export var SPEED = 5

func _process(delta: float) -> void:
	position = lerp(position, player.controller.global_position, SPEED * delta)
