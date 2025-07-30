extends CanvasLayer

@onready var winScreen = $Victory
@onready var looseScreen = $Defeat
@onready var helpScreen = $Help
@onready var playButotn = $Menu/PlayButton
@onready var helpButton = $Menu/HelpButton
@onready var menu = $Menu

@export var gameScene: PackedScene
var currentGamescene
var player
var dragon

func _process(delta: float) -> void:
	if player == null:
		return
	var end = false
	if player.health <= 0:
		looseScreen.visible = true
		looseScreen.disabled = false
		end = true
	elif dragon.health <= 0:
		winScreen.visible = true
		winScreen.disabled = false
		end = true
	if end:
		menu.visible = true
		currentGamescene.queue_free()
		currentGamescene = null
		player = null
		dragon = null

func hideLoose() -> void:
	looseScreen.visible = false
	looseScreen.disabled = true

func hideWin() -> void:
	winScreen.visible = false
	winScreen.disabled = true

func play() -> void:
	currentGamescene = gameScene.instantiate()
	get_parent().add_child(currentGamescene)
	dragon = currentGamescene.find_child("Dragon")
	player = currentGamescene.find_child("Player")
	menu.visible = false

func showHelp() -> void:
	helpScreen.visible = true
	helpScreen.disabled = false

func hideHelp() -> void:
	helpScreen.visible = false
	helpScreen.disabled = true
