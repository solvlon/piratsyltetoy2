extends CanvasLayer

@onready var player = $"../Player"
@onready var dragon = $"../Dragon"
@onready var winScreen = $Victory
@onready var looseScreen = $Defeat

func _process(delta: float) -> void:
	if player.health <= 0:
		looseScreen.visible = true
	elif dragon.health <= 0:
		winScreen.visible = true
