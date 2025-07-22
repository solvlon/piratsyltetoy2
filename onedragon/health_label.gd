extends RichTextLabel

@onready var player = $"../../Player"

func _physics_process(delta) -> void:
	text = str(player.health, " / ", player.maxHealth)
