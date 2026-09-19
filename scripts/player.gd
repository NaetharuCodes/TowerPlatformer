extends CharacterBody2D

enum ActionState {IDLE, WALK, DUCK, FLOAT, JUMP, LOOK_UP}
var actionState: ActionState = ActionState.IDLE

@onready var sprite = $AnimatedSprite2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction != 0:
		sprite.flip_h = direction < 0
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _update_animation():
	match(actionState):
		ActionState.IDLE:
			sprite.play("idle")
		ActionState.WALK:
			sprite.play("walk")
		ActionState.DUCK:
			sprite.play("duck")
		ActionState.FLOAT:
			sprite.play("float")
		ActionState.LOOK_UP:
			sprite.play("look_up")
