extends AudioStreamPlayer

@export var audio_library: AudioLibrary

var looping_streams: Dictionary


func _ready() -> void:
	audio_library = AudioLibrary.new()
	add_to_group("audio_player")
	stream = AudioStreamPolyphonic.new()
	
	if Globals.AUDIO_PLAYER != null:
		print("WARNING: Multiple audio players detected, last one to be initialized will be used as the interface for global methods and entry points")
	
	Globals.AUDIO_PLAYER = self
	
	_add_sounds_to_library()

func _get_sound_number(name: String) -> int:
	var regex = RegEx.new()
	regex.compile(r"_sn(\d+)$")
	var result = regex.search(name)
	if result:
		return int(result.get_string(1))
	return -1

func _add_sounds_to_library() -> void:
	var audio_files: Array = Globals.get_files_in_folder("res://assets/audio/sound_effects")
	for audio_file in audio_files:
		if not audio_file.ends_with(".mp3"):
			continue
		
		audio_file = "res://assets/audio/sound_effects/" + audio_file
		var file_name_no_postfix: String = audio_file.get_file().get_basename()
		var sound_number: int = _get_sound_number(audio_file)
		var sound_key: String = file_name_no_postfix
		
		var sound_effect: SoundEffect = null
		if sound_number != -1:
			sound_key = sound_key.replace("_sn" + str(sound_number), "")
			sound_effect = audio_library.get_sound_effect(sound_key)
		
		if sound_effect == null:
			sound_effect = SoundEffect.new()
			sound_effect.name = sound_key
			audio_library.sound_effects.append(sound_effect)
		
		var new_audio_stream := load(audio_file)
		sound_effect.streams.append(new_audio_stream)

func _process(_delta: float) -> void:
	if not playing:
		self.play()

	var polyphonic_stream_playback := self.get_stream_playback()
	for key in looping_streams:
		if not polyphonic_stream_playback.is_stream_playing(looping_streams[key][0]):
			looping_streams[key][0] = polyphonic_stream_playback.play_stream(audio_library.get_audio_stream(looping_streams[key][1]))

func play_sound(sound_name: String) -> bool:
	if sound_name:
		var audio_stream = audio_library.get_audio_stream(sound_name)
		if not audio_stream:
			if sound_name != "default":
				return play_sound("default")
			else:
				printerr("failed to get audio stream from sound with name: " + sound_name)
				return false
		
		if not playing:
			self.play()
		
		var polyphonic_stream_playback := self.get_stream_playback()
		polyphonic_stream_playback.play_stream(audio_stream)
		return true
	else:
		printerr("soundname is invalid, cannot play sound effect.")
		return false

func play_sound_looping(sound_name: String, key: String) -> bool:
	if sound_name:
		var audio_stream = audio_library.get_audio_stream(sound_name)
		if not audio_stream:
			if sound_name != "default":
				return play_sound("default")
			else:
				printerr("failed to get audio stream from sound with name: " + sound_name)
				return false
		
		if not playing:
			self.play()
		
		var polyphonic_stream_playback := self.get_stream_playback()
		var play_id = polyphonic_stream_playback.play_stream(audio_stream)
		looping_streams[key] = [play_id, sound_name]
		return true
	else:
		printerr("soundname is invalid, cannot play sound effect.")
		return false

func stop_sound_looping(key: String) -> bool:
	var looping_stream_meta = looping_streams.get(key)
	if not looping_stream_meta:
		printerr("no sound is currently looping for key: " + key)
		return false
		
	var polyphonic_stream_playback := self.get_stream_playback()
	polyphonic_stream_playback.stop_stream(looping_stream_meta[0])
	looping_streams.erase(key)
	return true
