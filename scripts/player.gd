extends CharacterBody2D
class_name Player

enum Facing {LEFT, RIGHT}
var facing: Facing = Facing.LEFT

enum ActionState {IDLE, WALK, JUMP, DUCK, LOOK_UP, FLOAT}
var action_state = ActionState.WALK 

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

# Special Moves
@export var wall_push: float = 150.0
var wall_jump_tokens: int = 1

@export var float_speed: float = 100.0

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		action_state = ActionState.WALK
		
		wall_jump_tokens = 1
		
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jump_power
			
	if is_on_wall() and not is_on_floor():
		if Input.is_action_just_pressed("jump") and wall_jump_tokens > 0:
			wall_jump_tokens -= 1
			velocity.y -= jump_power  * 0.75
			if facing == Facing.LEFT:
				velocity.x += wall_push
			else:
				velocity.x -= wall_push
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if Input.is_action_pressed("jump"):
			velocity.y = min(velocity.y, float_speed)
			action_state = ActionState.FLOAT
		else:
			velocity.y = min(velocity.y, max_fall_speed)
			action_state = ActionState.JUMP
			
			
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0:
		sprite.flip_h = true
		facing = Facing.LEFT
	elif direction > 0:
		sprite.flip_h = false
		facing = Facing.RIGHT
	
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
	
	if Input.is_action_pressed("look_up") and direction == 0:
		action_state = ActionState.LOOK_UP
		
	if Input.is_action_pressed("look_down") and direction == 0:
		action_state = ActionState.DUCK
	
	_update_animation()

func _update_animation() -> void:
	match(action_state):
		ActionState.WALK:
			sprite.play("walk")
		ActionState.JUMP:
			sprite.play("jump")
		ActionState.FLOAT:
			sprite.play("float")
		ActionState.LOOK_UP:
			sprite.play("look_up")
		ActionState.DUCK:
			sprite.play("duck")
