extends Node2D

var minutes: int = 0
var seconds: int = 0
var hundredths: int = 0
var time_passed: float = 0

@onready var time_label: Label = $World/CanvasLayer/Control/LevelTimer
@onready var p1_score_label = $World/CanvasLayer/Control/PlayerOneScore
@onready var p2_score_label = $World/CanvasLayer/Control/PlayerTwoScore

func _process(delta: float) -> void:
	time_passed += delta
	
	minutes = int(time_passed / 60)
	seconds = int(time_passed) % 60
	hundredths = int(fmod(time_passed, 1.0) * 100)
	
	time_label.text = "%02d:%02d:%02d" % [minutes, seconds, hundredths]
	
	p1_score_label.text = "P1: %02d" % [GameManager.p1_score]
	p2_score_label.text = "P2: %02d" % [GameManager.p2_score]
	
