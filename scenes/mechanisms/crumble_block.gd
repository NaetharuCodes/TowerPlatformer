extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var block: CollisionShape2D = $BlockCollision
@onready var zone: CollisionShape2D = $CrumbleZone/ZoneCollision

@export var crumble_delay: float = 1.0
var crumble_timer: float = crumble_delay
var crumble: bool = false

@export var reset_delay: float = 3.0
var reset_timer: float = reset_delay
var reset: bool = false

func _process(delta: float) -> void:
	
	print("Crumble: ", crumble)
	print("Reset: ", reset)
	
	if crumble: 
		
		crumble_timer -= delta
		
		if crumble_timer <= 0:
			block.disabled = true
			crumble = false
			reset = true
			sprite.hide()
			zone.disabled = true
			crumble_timer = crumble_delay
			
	if reset:
		
		reset_timer -= delta
		
		if reset_timer <= 0:
			block.disabled = false
			sprite.show()
			zone.disabled = false
			sprite.play("default")
			reset = false
			reset_timer = reset_delay
		
func _on_crumble_zone_body_entered(body: Node2D) -> void:
	sprite.play("crumble")
	crumble = true
