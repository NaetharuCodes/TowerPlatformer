# audio_manager.gd
extends Node

func play(stream: AudioStream, volume_db := 0.0, pitch := 1.0) -> void:
	var p := AudioStreamPlayer.new()
	p.stream = stream
	p.volume_db = volume_db
	p.pitch_scale = pitch
	p.bus = "SFX"
	add_child(p)
	p.finished.connect(p.queue_free)
	p.play()
