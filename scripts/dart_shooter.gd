extends Area2D

@export var rate_of_fire: float = 2.0
var shot_timer = 0.0

func _process(delta: float) -> void:
	if shot_timer > 0:
		shot_timer -= delta

func _on_body_entered(body: Node2D) -> void:
	if shot_timer <= 0:
		print("dart shooter tripped")
		shot_timer = rate_of_fire
