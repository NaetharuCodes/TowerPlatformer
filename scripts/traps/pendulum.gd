extends Area2D
class_name Pendulum

@export var swing_speed: float = 2.0
@export var swing_angle: float = 45.0
@export var knockback_power: float = 200.0

var time: float = 0.0

enum Swing_Direction {LEFT, RIGHT}
var swing_direction: Swing_Direction = Swing_Direction.LEFT

var _last_frame_cos: float = 0.0

func _process(delta: float) -> void:
	time += delta
	rotation = deg_to_rad(swing_angle) * sin(time * swing_speed)
	var direction = cos(time * swing_speed)
	
	if direction < _last_frame_cos:
		swing_direction = Swing_Direction.LEFT
	else:
		swing_direction = Swing_Direction.RIGHT
		
	_last_frame_cos = direction
	
func _on_body_entered(body: Player) -> void:
	
	var knockback_vector: Vector2
	
	if swing_direction == Swing_Direction.LEFT:
		knockback_vector = Vector2.LEFT * knockback_power
	else: 
		knockback_vector = Vector2.RIGHT * knockback_power
	
	body.apply_knockback(knockback_vector)
