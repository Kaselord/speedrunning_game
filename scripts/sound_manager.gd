extends Node

func new_sound(stream : String, pitch = 1.0, volume = 0.0):
	var streamplayer = AudioStreamPlayer.new()
	streamplayer.volume_db = volume
	streamplayer.stream = load(stream)
	add_child(streamplayer)
	streamplayer.pitch_scale = pitch
	streamplayer.play(0.0)
	await get_tree().create_timer(streamplayer.stream.get_length()).timeout
	streamplayer.call_deferred("free")
