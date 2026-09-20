extends Area2D

@export var rate_of_fire: float = 2.0
@export var dart: PackedScene
var shot_timer = 0.0

@export var move_speed: float = 100.0
@export var viewport: SubViewport

func _process(delta: float) -> void:
	if shot_timer > 0:
		shot_timer -= delta

func _on_body_entered(body: Node2D) -> void:
	if shot_timer <= 0:
		print("dart shooter tripped")
		shot_timer = rate_of_fire
		var new_dart: Dart = dart.instantiate()
		viewport.add_child.call_deferred(new_dart)
		new_dart.position = global_position
		print("new dart added")
	
