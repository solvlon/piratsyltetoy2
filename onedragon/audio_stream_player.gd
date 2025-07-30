extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(on_audio_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_audio_finished():
	pitch_scale = pitch_scale * 1.2
	play()
