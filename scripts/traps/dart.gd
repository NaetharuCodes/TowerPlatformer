extends Area2D
class_name Dart

enum Direction {LEFT, RIGHT}
@export var direction = Direction.RIGHT

@export var speed: float = 250.0

@export var knockback_power: float = 250.0

func _process(delta: float) -> void:
	if direction == Direction.RIGHT:
		position.x += speed * delta
	else:
		position.x -= speed * delta

func _on_body_entered(body: Player) -> void:
	var knockback_vector: Vector2
	
	if direction == Direction.RIGHT:
		knockback_vector = Vector2.RIGHT * knockback_power
	else:
		knockback_vector = Vector2.LEFT * knockback_power
	
	body.apply_knockback(knockback_vector)
	queue_free()
