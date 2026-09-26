extends CharacterBody2D

enum State { PATROL, WINDUP, CHARGE, RECOVER, FROZEN, THAW }

@export var speed := 40.0
@export var charge_speed := 160.0
@export var windup_time := 0.4
@export var charge_time := 0.8
@export var recover_time := 1.5
@export var knockback_force := Vector2(200, -150)

var direction := 1
var state := State.PATROL
var state_timer := 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var pivot: Node2D = $Pivot
@onready var sprite: AnimatedSprite2D = $Pivot/AnimatedSprite2D
@onready var wall_ray: RayCast2D = $Pivot/WallRay
@onready var edge_ray: RayCast2D = $Pivot/EdgeRay
@onready var sight_ray: RayCast2D = $Pivot/SightRay
@onready var hitbox: Area2D = $Pivot/Hitbox

@export var frozen_time: float = 2.0
@export var thaw_time: float = 0.5

func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	state_timer -= delta

	match state:
		State.PATROL:
			if is_on_floor() and (wall_ray.is_colliding() or not edge_ray.is_colliding()):
				turn_around()
			velocity.x = direction * speed
			if sees_player():
				print("I see the player")
				set_state(State.WINDUP, windup_time)
		State.WINDUP:
			velocity.x = 0
			sprite.position.x = randf_range(-1.0, 1.0)
			sprite.modulate = Color(3, 3, 3) if int(state_timer * 20) % 2 == 0 else Color.WHITE
			if state_timer <= 0:
				sprite.position.x = 0
				sprite.modulate = Color.WHITE
				set_state(State.CHARGE, charge_time)
		State.CHARGE:
			velocity.x = direction * charge_speed
			if wall_ray.is_colliding() or state_timer <= 0:
				set_state(State.RECOVER, recover_time)
		State.RECOVER:
			velocity.x = 0
			if state_timer <= 0:
				set_state(State.PATROL, 0)
		State.FROZEN:
			velocity.x = 0.0
			if state_timer <= 0.0:
				sprite.play("thaw")
				set_state(State.THAW, thaw_time)
		State.THAW:
			velocity.x = 0.0
			if state_timer <= 0.0:
				unfreeze()
				
	move_and_slide()

func set_state(new_state: State, time: float) -> void:
	state = new_state
	state_timer = time

func sees_player() -> bool:
	return sight_ray.is_colliding() and sight_ray.get_collider().is_in_group("player")

func turn_around() -> void:
	direction *= -1
	pivot.scale.x = direction
	wall_ray.force_raycast_update()
	edge_ray.force_raycast_update()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if state == State.CHARGE and body.has_method("apply_knockback"):
		body.apply_knockback(Vector2(knockback_force.x * direction, knockback_force.y))
		set_state(State.RECOVER, recover_time)
		
func freeze() -> void:
	sprite.position.x = 0.0
	sprite.modulate = Color.WHITE
	velocity.x = 0.0
	hitbox.set_deferred("monitoring", false)
	set_collision_layer_value(1, true)
	sprite.play("frozen")
	set_state(State.FROZEN, frozen_time)

func unfreeze() -> void:
	hitbox.set_deferred("monitoring", true)
	set_collision_layer_value(1, false)
	sprite.play("normal")
	set_state(State.PATROL, 0.0)
