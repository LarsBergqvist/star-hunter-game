extends Control

func _ready():
	$Menu/HBoxCharacters/Char1/Button.connect("pressed", self, "_on_CharButton_pressed", [1])
	$Menu/HBoxCharacters/Char3/Button.connect("pressed", self, "_on_CharButton_pressed", [3])
	$Menu/HBoxCharacters/Char4/Button.connect("pressed", self, "_on_CharButton_pressed", [4])
	$Menu/HBoxCharacters/Char5/Button.connect("pressed", self, "_on_CharButton_pressed", [5])
	$Menu/Back.connect("pressed", self, "_on_back_button_pressed")

	var global = get_node("/root/global")
	_on_CharButton_pressed(global.character)

func _on_back_button_pressed():
	self.queue_free()
	get_tree().change_scene("res://TitleScreen.tscn")

func _clear_all_selections():
	$Menu/HBoxCharacters/Char1/Button.modulate.a8 = 0
	$Menu/HBoxCharacters/Char3/Button.modulate.a8 = 0
	$Menu/HBoxCharacters/Char4/Button.modulate.a8 = 0
	$Menu/HBoxCharacters/Char5/Button.modulate.a8 = 0

func _on_CharButton_pressed(character):
	_clear_all_selections()
	self.get_node("Menu/HBoxCharacters/Char" + str(character) + "/Button").modulate.a8 = 255
	var global = get_node("/root/global")
	global.character = character
