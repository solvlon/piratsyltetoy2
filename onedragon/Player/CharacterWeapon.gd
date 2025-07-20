extends Node2D

@export var player: CharacterBody2D
@export var attach: Node2D

@export var FOLLOW_SPEED = 40
@export var FOLLOW_VEL_OFFSET = 0.02

func _process(delta: float) -> void:
	global_position = lerp(global_position, 
		attach.global_position + player.velocity * FOLLOW_VEL_OFFSET, FOLLOW_SPEED * delta)
