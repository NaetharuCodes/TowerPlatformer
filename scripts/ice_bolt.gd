extends Area2D
class_name IceBolt

@export var move_speed: float = 250.0
@export var direction: Vector2 = Vector2.RIGHT
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if direction == Vector2.LEFT:
		sprite.flip_h = true

func _physics_process(delta: float) -> void:
	position += direction * move_speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
