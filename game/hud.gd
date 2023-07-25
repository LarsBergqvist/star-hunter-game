extends CanvasLayer

var _gamePadLeft = null
var _actionButtons = null
var _processCount = 0
var _processCountOnLastPausePress = 0

func update_HUD(score: int, total_stars: int, stars_found: int, health: int, max_health: int, current_level_number: int)->void:
	$GUI.score = score
	$GUI.stars_remaining = total_stars - stars_found
	$GUI.total_stars = total_stars
	$GUI.stars_found = stars_found
	$GUI.health = health
	$GUI.max_health = max_health
	$GUI.level = current_level_number


func init():
	pass
	
func _ready()->void:
	$PauseMenu.connect("requested_resume_game", self, "_on_requested_resume_game")
	$PauseMenu.connect("requested_start_new_game", self, "_on_requested_start_new_game")
	$PauseMenu.connect("requested_replay_level", self, "_on_requested_replay_level")
	$PauseMenu.connect("requested_goto_next_level", self, "_on_requested_goto_next_level")



func _on_requested_goto_next_level():
	get_parent().next_level()
	
func _on_requested_replay_level():
	get_parent().restart_from_current_level()
	
func _on_requested_resume_game():
	get_tree().paused = false

func _on_requested_start_new_game():
	get_parent().go_to_title_screen()
	
func _process(_delta):
	pass
	_processCount += 1
	if Input.is_action_pressed("pause"):
		if (_processCount - 20) < _processCountOnLastPausePress:
			return

		_processCountOnLastPausePress = _processCount
		if (get_tree().paused):
			$PauseMenu.hide_menu()
			_on_requested_resume_game()
		else:
			$PauseMenu.show_game_paused_menu()
			get_tree().paused = true


func show_game_over_menu():
	$PauseMenu.show_game_over_menu()


func show_level_complete_menu():
	$PauseMenu.show_level_complete_menu()
