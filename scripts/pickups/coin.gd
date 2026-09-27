extends Area2D

@export var sound: AudioStream

func _on_body_entered(body: Player) -> void:
	AudioManager.play(sound, -20.0, randf_range(0.98, 1.02))
	GameManager.add_score(body.player_number)
	queue_free()
