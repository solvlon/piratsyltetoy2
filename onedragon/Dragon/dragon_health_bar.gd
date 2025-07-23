extends ProgressBar

@onready var dragon: Dragon = $"../../Dragon"

func _ready() -> void:
	max_value = dragon.maxHealth

func _physics_process(delta) -> void:
	value = dragon.health
