extends Area2D
class_name FireBall

signal  spawned

@export var damages = 50
@export var force = 500
const SPEED = 300

@onready var spawn_animated_sprite_2d: AnimatedSprite2D = %SpawnAnimatedSprite2D
@onready var hit_animated_sprite_2d: AnimatedSprite2D = %HitAnimatedSprite2D
@onready var sprite_2d: Sprite2D = %Sprite2D

var move_direction : Vector2
# Called every frame. 'delta' is the elapsed time since the previous frame.
var _moving = false


func _ready() -> void:
	spawn_animated_sprite_2d.play("default")
	sprite_2d.hide()
	spawn_animated_sprite_2d.show()
	await spawn_animated_sprite_2d.animation_finished
	_moving = true
	sprite_2d.show()
	spawn_animated_sprite_2d.hide()
	spawned.emit()
	
func _process(delta: float) -> void:
	if _moving:
		position += move_direction*delta * SPEED

func _on_despawn_timer_timeout() -> void:
	_despawn()

func _on_body_enter(body) -> void:
	if body is PlayerController: 
		body.player.on_hit(damages, move_direction * force)
		_despawn()

func _despawn():
	sprite_2d.hide()
	hit_animated_sprite_2d.show()
	hit_animated_sprite_2d.play("default")
	await hit_animated_sprite_2d.animation_finished
	queue_free()
