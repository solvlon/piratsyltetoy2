extends ProgressBar

@onready var player = $"../../Player"
@onready var lbl = $HealthLabel

func _physics_process(delta) -> void:
	value = player.health
	max_value = player.maxHealth
	lbl.text = str(player.health, " / ", player.maxHealth)
