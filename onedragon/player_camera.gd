extends Camera2D

@onready var target = $"../Player/PlayerController"

@export var player :Player
@export var SPEED = 10

func _process(delta: float) -> void:
	position = lerp(position, player.player_controller.global_position, SPEED * delta)
