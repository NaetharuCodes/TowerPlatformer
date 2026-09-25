extends Camera2D

@export var player: Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = player.position.y
	
