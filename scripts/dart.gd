extends Area2D
class_name Dart

@export var speed: float = 150.0


func _ready() -> void:
	print("New dart in play")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta

func _on_body_entered(body: Node2D) -> void:
	print("I entered the area of: ", body)
	queue_free()
