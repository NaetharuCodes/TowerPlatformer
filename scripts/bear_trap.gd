extends Area2D

enum TrapState {PRIMED, SPRUNG}
var trap_state = TrapState.PRIMED

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("idle")
	
func _on_body_entered(body: Node2D) -> void:
	
	if trap_state == TrapState.PRIMED:
		trap_state = TrapState.SPRUNG
		print("you sprung the trap")
		sprite.play("snap")
