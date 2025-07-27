extends CharacterBody2D
class_name Dragon


const SPEED = 200.0
const ATTACK_MIN_WAIT_TIME = 3
const ATTACK_MAX_WAIT_TIME = 6
const FIREBALL = preload("res://Dragon/fireball.tscn")


@export var player : Player
@export var maxHealth = 1000
var health

var _is_attacking = false
var _spawn_position


@onready var navigation_agent_2d: NavigationAgent2D = %NavigationAgent2D
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var fire_attack_area: Area2D = %FireAttackArea
@onready var tile_swipe_area: Area2D = %TileSwipeArea
@onready var claw_attack_area: Area2D = %ClawAttackArea
@onready var fire_particles: GPUParticles2D = %FireParticles
@onready var animation_player: AnimationPlayer = %AnimationPlayer
#@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var fire_pre_particles: GPUParticles2D = %FirePreParticles
@onready var follow_area: Area2D = %FollowArea
@onready var fireball_spawn_left: Node2D = %fireballSpawn_left
@onready var fireball_spawn_right: Node2D = %fireballSpawn_right
@onready var fireball_spawn_up: Node2D = %fireballSpawn_up
@onready var fireball_spawn_down: Node2D = %fireballSpawn_down

var _fliped = false
var fireball_spawn : Node2D = fireball_spawn_left
var has_target := false

func _ready() -> void:
	health = maxHealth
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	_spawn_position = global_position

func _physics_process(_delta: float) -> void:
	
	if follow_area.get_overlapping_bodies().has(player.controller):
		if not has_target:
			has_target = true
			Globals.play_sound("dragon_engage")
		navigation_agent_2d.target_position = player.controller.global_position
	else:
		navigation_agent_2d.target_position = _spawn_position
	
	if not navigation_agent_2d.is_navigation_finished() and not _is_attacking:
		velocity =  position.direction_to( navigation_agent_2d.get_next_path_position())* SPEED
	else : 
		velocity = Vector2.ZERO

	move_and_slide()


func _process(delta: float) -> void:

	if velocity:
		if velocity.angle() > -PI/4  and velocity.angle() < PI/4:
			animated_sprite_2d.play("walk_right")
			
			if  _fliped:
				print ("right")
				animated_sprite_2d.scale.x *= -1
				_fliped = false
			fireball_spawn = fireball_spawn_right
			#rotation = 0
		if velocity.angle() > PI/4  and velocity.angle() < 3*PI/4:
			animated_sprite_2d.play("walk_down")
			if  _fliped:
				animated_sprite_2d.scale.x *=  -1
				_fliped = false
			fireball_spawn = fireball_spawn_down
			#rotation = 0
		if velocity.angle() > 3*PI/4  or velocity.angle() < -3*PI/4:
			
			animated_sprite_2d.play("walk_right")
			if not _fliped:
				print ("left")
				animated_sprite_2d.scale.x *=  -1
				_fliped = true
			fireball_spawn = fireball_spawn_left
			
		if velocity.angle() < -PI/4  and velocity.angle() > -3*PI/4:
			animated_sprite_2d.play("walk_up")
			if  _fliped:
				animated_sprite_2d.scale.x *=  -1
				_fliped = false
			fireball_spawn = fireball_spawn_up
		#print(_fliped)

func _on_attack_cooldown_timeout():
	
	if claw_attack_area.get_overlapping_bodies().has(player.controller):
		_claw_attack()
	elif tile_swipe_area.get_overlapping_bodies().has(player.controller):
		_tile_swipe_attack()
	elif fire_attack_area.get_overlapping_bodies().has(player.controller):
		_fire_attack()
	
	attack_cooldown.start(randf_range(ATTACK_MIN_WAIT_TIME,ATTACK_MAX_WAIT_TIME))

func _fire_attack():
	_is_attacking = true
	#fire_pre_particles.emitting = true
	#await fire_pre_particles.finished
	#fire_particles.emitting = true
	var fireball : FireBall = FIREBALL.instantiate()
	fireball.position = fireball_spawn.position
	fireball.move_direction = position.direction_to(player.controller.global_position)
	add_child(fireball)
	fire_particles.rotation = position.direction_to(player.controller.global_position).angle()
	Globals.play_sound("fireburst")
	await  fireball.spawned
	await  get_tree().create_timer(.5).timeout
	_is_attacking = false

func _tile_swipe_attack():
	_is_attacking = true
	animation_player.play("TileSwipeAttack")
	Globals.play_sound("dragon_growl")
	Globals.play_sound("tail_swipe")
	await  animation_player.animation_finished
	_is_attacking = false
	
func _claw_attack():
	_is_attacking = true
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d,"position",position.direction_to(player.global_position) * 20, 0.1) 
	tween.tween_property(animated_sprite_2d,"position",Vector2.ZERO, 0.4) 
	Globals.play_sound("dragon_growl")
	await  tween.finished
	_is_attacking = false
	
func on_hit(hitpoints, force):
	health -= hitpoints
	animation_player.play("Hit")
