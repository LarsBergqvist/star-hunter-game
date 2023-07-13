extends Control

signal requested_resume_game
signal requested_start_new_game
signal requested_replay_level
signal requested_goto_next_level

func show_game_paused_menu():
	$Message.text = "Game paused"
	$Message.show()
	$GamePaused.show()


func show_game_over_menu():
	$Message.text = "Game over"
	$Message.show()
	$GameOver.show()

func show_level_complete_menu():
	$Message.text = "Level complete!"
	$Message.show()
	$LevelComplete.show()

func hide_menu():
	$Message.hide()
	$LevelComplete.hide()
	$GamePaused.hide()
	$GameOver.hide()

func _on_Replay_pressed():
	hide_menu()
	emit_signal("requested_replay_level")
	pass # Replace with function body.


func _on_NextLevel_pressed():
	hide_menu()
	emit_signal("requested_goto_next_level")
	pass # Replace with function body.


func _on_Resume_pressed():
	hide_menu()
	emit_signal("requested_resume_game")


func _on_NewGame_pressed():
	hide_menu()
	emit_signal("requested_start_new_game")
