extends Area2D

enum TrapState {PRIMED, SPRUNG}
var trap_state = TrapState.PRIMED

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("idle")
	
func _on_body_entered(body: Player) -> void:
	
	if trap_state == TrapState.PRIMED:
		trap_state = TrapState.SPRUNG
		sprite.play("snap")
		body.apply_immobile(2.0)
