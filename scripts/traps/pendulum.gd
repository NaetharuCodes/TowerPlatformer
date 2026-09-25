extends Area2D
class_name Pendulum

@export var swing_speed: float = 2.0
@export var swing_angle: float = 45.0

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	rotation = deg_to_rad(swing_angle) * sin(time * swing_speed)
	
func _on_body_entered(body: Node2D) -> void:
	print("ouch you got hit by the pendulum")
