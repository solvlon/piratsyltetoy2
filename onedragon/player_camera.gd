extends Camera2D

@onready var target = $"../Player"

@export var SPEED = 10

func _process(delta: float) -> void:
	position = lerp(position, target.position, SPEED * delta)
