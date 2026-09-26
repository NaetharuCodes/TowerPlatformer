extends Area2D

@export var sound: AudioStream

func _on_body_entered(body: Node2D) -> void:
	AudioManager.play(sound, -20.0, randf_range(0.98, 1.02))
	queue_free()
