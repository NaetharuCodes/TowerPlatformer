extends Area2D
class_name Lava

@export var move_speed: float = 50.0

func _physics_process(delta: float) -> void:
	position.y -= move_speed * delta


func _on_body_entered(body: Node2D) -> void:
	print("the player died")
