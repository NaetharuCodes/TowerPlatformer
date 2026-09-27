extends Node

enum GameState {READY, ACTIVE, GAME_OVER, WIN}
var game_state: GameState = GameState.READY

var winner: int = 0

var p1_score: int = 0
var p2_score: int = 0

func get_ready_to_start() -> void:
	pass
	
func game_over() -> void:
	pass
	
func level_win(player_id: int) -> void:
	game_state = GameState.WIN
	winner = player_id
	get_tree().change_scene_to_file("res://scenes/screens/win_screen.tscn")
#	Load the win screen
#	Show the winner on a podium
# 	Show their time?
#	Cycle back to level select

func add_score(player_id: int) -> void:
	if player_id == 1:
		p1_score += 1
	
	if player_id == 2:
		p1_score += 1
		
	print("Player one score is: ", p1_score)
	print("Player two score is: ", p2_score)
