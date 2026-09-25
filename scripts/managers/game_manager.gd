extends Node

enum GameState {READY, ACTIVE, GAME_OVER, WIN}
var game_state: GameState = GameState.READY

func get_ready_to_start() -> void:
	pass
	
func game_over() -> void:
	pass
	
func level_win() -> void:
	pass
