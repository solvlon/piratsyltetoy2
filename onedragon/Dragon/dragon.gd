extends CharacterBody2D
class_name Dragon

const SPEED = 200.0

@export var player : Player

@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D


func _physics_process(_delta: float) -> void:
	
	navigation_agent_2d.target_position = player.position
	
	
	if not navigation_agent_2d.is_navigation_finished():
		velocity =  position.direction_to( navigation_agent_2d.get_next_path_position())* SPEED
	else : 
		velocity = Vector2.ZERO

	move_and_slide()
