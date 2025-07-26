extends Sprite2D

func _process(_delta):
	for child in get_children():
		child.play("flame")
