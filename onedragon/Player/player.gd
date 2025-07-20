extends Node2D

@onready var target = $PlayerController/Sprite2D/WeaponAttach

@export var SPEED = 10

func _process(delta: float) -> void:
	position = lerp(position, target.position, SPEED * delta)
