extends Control

func _ready()->void:
	$Menu/NewGame.connect("pressed", self, "_on_newgame_button_pressed")
	$Menu/Options.connect("pressed", self, "_on_options_button_pressed")


func _on_newgame_button_pressed()->void:
	self.queue_free()
	get_tree().change_scene("res://main.tscn")


func _on_options_button_pressed()->void:
	self.queue_free()
	get_tree().change_scene("res://OptionsScreen.tscn")
