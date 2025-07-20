extends Resource
class_name SoundEffect

@export var name: String
@export var streams: Array[AudioStream]

var RNG = RandomNumberGenerator.new()

var prev_index := 0

func get_stream() -> AudioStream:
	if streams.size() == 0:
		printerr("attempt to fetch audio stream from sound effect with name " + name + ", but no streams are attached to it.")
		return null

	var index := RNG.randi_range(0, streams.size() - 1)
	if index == prev_index:
		index = (index + 1) % (streams.size())
	
	prev_index = index
	return streams[index]
