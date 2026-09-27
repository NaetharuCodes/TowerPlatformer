extends Area2D

enum Direction {LEFT, RIGHT}
@export var direction = Direction.LEFT
@export var knockback_power: float = 400.0

func _on_body_entered(body: Player) -> void:
	var knockback_vector: Vector2
	
	if direction == Direction.LEFT:
		knockback_vector = Vector2.LEFT * knockback_power
	else:
		knockback_vector = Vector2.RIGHT * knockback_power
		
	knockback_vector.y = -(knockback_power / 2)
		
	body.apply_knockback(knockback_vector)
