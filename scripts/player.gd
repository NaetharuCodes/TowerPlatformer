extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Movements
@export var max_speed: float = 200.0
@export var acceleration: float = 1200.0
@export var friction: float = 2000.0

# Air
@export var air_acceleration: float = 400.0
@export var air_friction: float = 200.0
@export var gravity: float = 1000.0
@export var max_fall_speed: float = 400.0

# Jump
@export var jump_power: float = 400.0

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jump_power
	
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
	
	var accel
	var decel
	
	if is_on_floor():
		accel = acceleration
		decel = friction
	else:
		accel = air_acceleration
		decel = air_friction
	
	if direction == 0:
		velocity.x = move_toward(velocity.x, max_speed * direction, decel * delta)
	else:
		velocity.x = move_toward(velocity.x, max_speed * direction, accel * delta)
		
	move_and_slide()
