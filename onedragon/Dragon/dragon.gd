extends CharacterBody2D
class_name Dragon


const SPEED = 200.0
const ATTACK_MIN_WAIT_TIME = 3
const ATTACK_MAX_WAIT_TIME = 6



@export var player : Player

var _is_attacking = false


@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var fire_attack_area: Area2D = %FireAttackArea
@onready var tile_swipe_area: Area2D = %TileSwipeArea
@onready var claw_attack_area: Area2D = %ClawAttackArea
@onready var fire_particles: GPUParticles2D = %FireParticles
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)

func _physics_process(_delta: float) -> void:
	
	navigation_agent_2d.target_position = player.player_controller.global_position
	
	
	if not navigation_agent_2d.is_navigation_finished() and not _is_attacking:
		velocity =  position.direction_to( navigation_agent_2d.get_next_path_position())* SPEED
	else : 
		velocity = Vector2.ZERO

	move_and_slide()



func _on_attack_cooldown_timeout():
	
	if claw_attack_area.get_overlapping_bodies().has(player):
		_claw_attack()
	elif tile_swipe_area.get_overlapping_bodies().has(player):
		_tile_swipe_attack()
	elif fire_attack_area.get_overlapping_bodies().has(player):
		_fire_attack()	
	
	print("draggon attacks")
	attack_cooldown.start(randf_range(ATTACK_MIN_WAIT_TIME,ATTACK_MAX_WAIT_TIME))

func _fire_attack():
	print("fire attack")
	_is_attacking = true
	fire_particles.emitting = true
	fire_particles.rotation = position.direction_to(player.position).angle()
	await  fire_particles.finished
	_is_attacking = false

func _tile_swipe_attack():
	print ("tile swipe")
	_is_attacking = true
	animation_player.play("TileSwipeAttack")
	await  animation_player.animation_finished
	_is_attacking = false
	
func _claw_attack():
	print("claw attack")
	_is_attacking = true
	var tween = create_tween()
	tween.tween_property(sprite_2d,"position",position.direction_to(player.position) * 20, 0.1) 
	tween.tween_property(sprite_2d,"position",Vector2.ZERO, 0.4) 
	await  tween.finished
	_is_attacking = false
	
	
