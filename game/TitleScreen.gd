extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/NewGame.connect("pressed", self, "_on_button_pressed")


func _on_button_pressed():
	get_tree().change_scene("res://main.tscn")
