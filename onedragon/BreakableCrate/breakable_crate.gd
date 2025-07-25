extends RigidBody2D

@export var objToSpawn: PackedScene
@export var disableCollisionOnOpen = true

@onready var normalImage = $Normal
@onready var destroyedImage = $Destroyed
@onready var collisionShape = $CollisionShape2D

func on_hit(power, force):
	normalImage.visible = false
	destroyedImage.visible = true
	if disableCollisionOnOpen:
		collisionShape.set_deferred("disabled", true)
	var obj = objToSpawn.instantiate()
	add_child(obj)
	obj.global_position = global_position
