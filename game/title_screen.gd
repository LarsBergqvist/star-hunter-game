extends Control

onready var _transition_rect := $SceneTransitionRect

func _ready()->void:
	$Menu/NewGame.connect("pressed", self, "_on_newgame_button_pressed")
	$Menu/Options.connect("pressed", self, "_on_options_button_pressed")
	$Menu/Leaderboard.connect("pressed", self, "_on_leaderboard_button_pressed")
	$Menu/Instructions.connect("pressed", self, "_on_instructions_button_pressed")


func _on_newgame_button_pressed()->void:
	_transition_rect.transition_to("res://main.tscn", self)

func _on_options_button_pressed()->void:
	_transition_rect.transition_to("res://options_screen.tscn", self)
	
func _on_leaderboard_button_pressed()->void:
	_transition_rect.transition_to("res://highscores/leaderboard.tscn", self)
	
	
func _on_instructions_button_pressed()->void:
	_transition_rect.transition_to("res://instructions.tscn", self)

