extends CanvasLayer

signal requested_resume_game
signal requested_start_new_game
signal requested_replay_level
signal requested_goto_next_level

func show_game_paused_menu():
	$Message.text = "Game paused"
	$Message.show()
	$GamePausedMenu.show()


func show_game_over_menu():
	$Message.text = "Game over..."
	$Message.show()
	$GameOverMenu.show()

func show_level_complete_menu():
	$Message.text = "Level complete!"
	$Message.show()
	$LevelCompleteMenu.show()

func hide_menu():
	$Message.hide()
	$GamePausedMenu.hide()
	$GameOverMenu.hide()
	$LevelCompleteMenu.hide()

func _on_GamePausedMenu_item_selected(index):
	hide_menu()
	if (index == 0):
		emit_signal("requested_resume_game")
	elif (index == 1):
		emit_signal("requested_start_new_game")


func _on_GameOverMenu_item_selected(index):
	hide_menu()
	if (index == 0):
		emit_signal("requested_replay_level")
	elif (index == 1):
		emit_signal("requested_start_new_game")


func _on_LevelCompleteMenu_item_selected(index):
	hide_menu()
	if (index == 0):
		emit_signal("requested_goto_next_level")
	elif (index == 1):
		emit_signal("requested_replay_level")
