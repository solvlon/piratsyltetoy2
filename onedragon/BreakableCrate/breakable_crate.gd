extends RigidBody2D

@export var objToSpawn: PackedScene
@export var disableCollisionOnOpen = true
@export var soundOnOpen = "break"

@onready var normalImage = $Normal
@onready var destroyedImage = $Destroyed
@onready var collisionShape = $CollisionShape2D

var _isOpen = false

func on_hit(power, force):
	if _isOpen:
		return
	_isOpen = true
	normalImage.visible = false
	destroyedImage.visible = true
	Globals.play_sound(soundOnOpen)
	if disableCollisionOnOpen:
		collisionShape.set_deferred("disabled", true)
	else:
		# disable collisions with weapon
		collision_layer = 32
		collision_mask = 32
	var obj = objToSpawn.instantiate()
	get_parent().add_child(obj)
	obj.global_position = global_position
