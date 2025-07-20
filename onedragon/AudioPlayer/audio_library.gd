extends Resource
class_name AudioLibrary

@export var sound_effects: Array[SoundEffect]

func get_audio_stream(name: String) -> AudioStream:
	var sound_effect: SoundEffect = get_sound_effect(name)
	if sound_effect != null:
		return sound_effect.get_stream()
	return null

func get_sound_effect(name: String) -> SoundEffect:
	var index := -1
	
	if name:
		for sound_effect in sound_effects:
			index += 1
			
			if name == sound_effect.name:
				return sound_effects[index]
	else:
		printerr("sound name: " + name + " was empty or null, cannot fetch audio stream.")
		return null
	
	return null

func print_sound_effects() -> void:
	for sound_effect in sound_effects:
		print(sound_effect.name)
