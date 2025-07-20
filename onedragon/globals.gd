extends Node

var AUDIO_PLAYER = null

func _ready() -> void:
	pass

func play_sound(sound_name: String) -> bool:
	if not sound_name:
		printerr("sound_name was invalid or empty, cannot play sound.")
		return false

	if not AUDIO_PLAYER:
		printerr("no audio player node available, add one to play sounds!")
		return false
	
	var success: bool = AUDIO_PLAYER.play_sound(sound_name)
	return success

func play_sound_looping(sound_name: String, key: String) -> bool:
	if not sound_name:
		printerr("sound_name was invalid or empty, cannot play sound")
		return false

	if not AUDIO_PLAYER:
		printerr("no audio player node available, add one to play sounds!")
		return false
	
	var success: bool = AUDIO_PLAYER.play_sound_looping(sound_name, key)
	return success

func stop_sound_looping(key: String) -> bool:
	if not AUDIO_PLAYER:
		printerr("no audio player node available, add one to play sounds!")
		return false
	
	var success: bool = AUDIO_PLAYER.stop_sound_looping(key)
	return success

func get_files_in_folder(path: String) -> Array:
	var files := []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Could not open directory: " + path)
	return files
