extends CharacterBody2D
class_name Player

enum Facing {LEFT, RIGHT}
var facing: Facing = Facing.LEFT

enum ActionState {IDLE, WALK, JUMP, DUCK, LOOK_UP, FLOAT}
var action_state: ActionState = ActionState.WALK

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio

# Player
@export var player_number: int = 1

# Movement
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

# Wall jump
@export var wall_push: float = 150.0
var wall_jump_tokens: int = 1

# Float
@export var float_speed: float = 100.0
@export var max_float_time: float = 0.5
@export var float_acceleration: float = 800.0
@export var float_friction: float = 600.0
var float_timer: float = 0.0

# Knockback
@export var knockback_speed: float = 100.0
@export var knockback_time: float = 0.25
var knockback_timer: float = 0.0

# Idle
@export var idle_delay: float = 3.0
var idle_timer: float = 0.0

# Ice Bolts
@export var ice_bolt: PackedScene
@export var ice_bolt_delay: float = 2.0
var ice_bolt_timer = 0.0


func _physics_process(delta: float) -> void:
	_move(delta)
	_update_animation()
	_shoot_ice_bolt(delta)

func _action(action_name: String) -> String:
	return "p%d_%s" % [player_number, action_name]

func _move(delta: float) -> void:
	if knockback_timer > 0.0:
		knockback_timer -= delta
		velocity.y += gravity * delta
		move_and_slide()
		return

	# On the floor: reset abilities and allow jumping
	if is_on_floor():
		action_state = ActionState.WALK
		wall_jump_tokens = 1
		float_timer = max_float_time

		if Input.is_action_just_pressed(_action("jump")):
			velocity.y = -jump_power
			print("playing jump audio")
			jump_audio.pitch_scale = randf_range(1.6, 1.9)
			jump_audio.play()

	# Wall jump: fixed height, pushed away from the wall
	if is_on_wall() and not is_on_floor():
		if Input.is_action_just_pressed(_action("jump")) and wall_jump_tokens > 0:
			wall_jump_tokens -= 1
			velocity.y = -jump_power * 0.75
			velocity.x = get_wall_normal().x * wall_push
			jump_audio.pitch_scale = randf_range(1.6, 1.9)
			jump_audio.play()

	# In the air: gravity, and float only while falling
	if not is_on_floor():
		velocity.y += gravity * delta

		var falling: bool = velocity.y > 0
		if falling and Input.is_action_pressed(_action("jump")) and float_timer > 0:
			float_timer -= delta
			velocity.y = min(velocity.y, float_speed)
			action_state = ActionState.FLOAT
		else:
			velocity.y = min(velocity.y, max_fall_speed)
			action_state = ActionState.JUMP

	# Facing
	var direction: float = Input.get_axis(_action("move_left"), _action("move_right"))

	if direction < 0:
		sprite.flip_h = true
		facing = Facing.LEFT
	elif direction > 0:
		sprite.flip_h = false
		facing = Facing.RIGHT

	# Horizontal movement
	var accel: float
	var decel: float

	if is_on_floor():
		accel = acceleration
		decel = friction
	elif action_state == ActionState.FLOAT:
		accel = float_acceleration
		decel = float_friction
	else:
		accel = air_acceleration
		decel = air_friction

	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, decel * delta)
	else:
		velocity.x = move_toward(velocity.x, max_speed * direction, accel * delta)

	move_and_slide()

	# Look up / duck (floor only)
	if is_on_floor() and direction == 0:
		if Input.is_action_pressed(_action("look_up")):
			action_state = ActionState.LOOK_UP
		if Input.is_action_pressed(_action("look_down")):
			action_state = ActionState.DUCK

	# Idle after standing still for a while
	if is_on_floor() and velocity == Vector2.ZERO and action_state == ActionState.WALK:
		idle_timer += delta
		if idle_timer >= idle_delay:
			action_state = ActionState.IDLE
	else:
		idle_timer = 0.0

func _update_animation() -> void:
	match action_state:
		ActionState.IDLE:
			sprite.play("idle")
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

func die() -> void:
	print("i died")

func _shoot_ice_bolt(delta: float) -> void:
	if ice_bolt_timer > 0:
		ice_bolt_timer -= delta
		return

	if Input.is_action_just_pressed(_action("ice_bolt")):
		ice_bolt_timer = ice_bolt_delay

		var bolt = ice_bolt.instantiate()
		bolt.direction = Vector2.RIGHT if facing == Facing.RIGHT else Vector2.LEFT
		bolt.global_position = global_position
		get_parent().add_child(bolt)

func apply_knockback(force: Vector2) -> void:
	velocity = force
	knockback_timer = knockback_time
