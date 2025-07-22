extends Node2D
class_name Player

@onready var player_controller = $PlayerController

@export var maxHealth = 100
@export var health = 100

func on_hit(hitpoints, force) -> void:
	health -= hitpoints
	player_controller.on_hit(force)

func heal(points) -> void:
	health = clamp(health + points, 0, maxHealth)

func up_max_health(v) -> void:
	maxHealth += v
	health += v

func up_dash_dist(v) -> void:
	player_controller.dashSpeedMultiplier *= v

func up_dash_speed(v) -> void:
	player_controller.dashRecoveryTime *= v
