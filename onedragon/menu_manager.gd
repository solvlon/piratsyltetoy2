extends CanvasLayer

var player
var dragon
@onready var winScreen = $Victory
@onready var looseScreen = $Defeat
@onready var helpScreen = $Help
@onready var playButotn = $Menu/PlayButton
@onready var helpButton = $Menu/HelpButton

func _process(delta: float) -> void:
	if player.health <= 0:
		looseScreen.visible = true
	elif dragon.health <= 0:
		winScreen.visible = true

func showHelp() -> void:
	helpScreen.visible = true

func hideHelp() -> void:
	helpScreen.visible = false
