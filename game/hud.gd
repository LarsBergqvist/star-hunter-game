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
	if (_gamePadLeft != null):
		remove_child(_gamePadLeft)
	var gamePadLeftScene = load("res://gamepad_left.tscn")
	_gamePadLeft = gamePadLeftScene.instance()
	add_child(_gamePadLeft)

	if (_actionButtons != null):
		remove_child(_actionButtons)
	var actionButtonsScene = load("res://action_buttons.tscn")
	_actionButtons = actionButtonsScene.instance()
	add_child(_actionButtons)
	

func _process(_delta):
	_processCount += 1
	if Input.is_action_pressed("pause"):
		if (_processCount - 20) < _processCountOnLastPausePress:
			return

		_processCountOnLastPausePress = _processCount
		if (get_tree().paused):
			get_tree().paused = false
			$VBox/Menu.hide()
			$Message.hide()
			$VBox.hide()
		else:
			show_game_paused_menu()
			get_tree().paused = true


const RESUME_GAME = 1
const START_NEW_GAME = 2
const GO_TO_NEXT_LEVEL = 4
const REPLAY_FROM_CURRENT_LEVEL = 5
func show_game_paused_menu():
	$Message.text = "Game paused"
	$Message.show()
	$VBox/Menu.clear()
	$VBox/Menu.add_item("Resume game", RESUME_GAME)	
	$VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$VBox/Menu.popup()
	$VBox.show()


func show_game_over_menu():
	$Message.text = "Game over..."
	$Message.show()
	$VBox/Menu.clear()
	$VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$VBox/Menu.popup()
	$VBox.show()


func show_level_complete_menu():
	$Message.text = "Level complete!"
	$Message.show()
	$VBox/Menu.clear()
	$VBox/Menu.add_item("Go to next level", GO_TO_NEXT_LEVEL)
	$VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$VBox/Menu.popup()
	$VBox.show()


func show_game_complete_menu():
	$Message.text = "Game complete!!!"
	$Message.show()
	$VBox/Menu.clear()
	$VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$VBox/Menu.popup()
	$VBox.show()


func _on_Menu_id_pressed( ID ):
	if ID == RESUME_GAME:
		get_tree().paused = false
		$VBox/Menu.hide()
		$Message.hide()
		$VBox.hide()
	elif ID == START_NEW_GAME:
		get_parent().go_to_title_screen()
	elif ID == REPLAY_FROM_CURRENT_LEVEL:
		get_parent().restart_from_current_level()
		$Message.hide()
		$VBox/Menu.hide()
		$VBox.hide()
	elif ID == GO_TO_NEXT_LEVEL:
		get_parent().next_level()
		$Message.hide()
		$VBox/Menu.hide()
		$VBox.hide()
	
