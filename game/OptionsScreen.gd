extends Control

func _ready():
	$Menu/HBoxCharacters/Char1/Button.connect("pressed", self, "_on_CharButton_pressed", [1])
	$Menu/HBoxCharacters/Char3/Button.connect("pressed", self, "_on_CharButton_pressed", [3])
	$Menu/HBoxCharacters/Char4/Button.connect("pressed", self, "_on_CharButton_pressed", [4])
	$Menu/HBoxCharacters/Char5/Button.connect("pressed", self, "_on_CharButton_pressed", [5])

	$Menu/HBoxLevels/Lev1.connect("pressed", self, "_on_LevelButton_pressed", [1])
	$Menu/HBoxLevels/Lev2.connect("pressed", self, "_on_LevelButton_pressed", [2])
	$Menu/HBoxLevels/Lev3.connect("pressed", self, "_on_LevelButton_pressed", [3])
	$Menu/HBoxLevels/Lev4.connect("pressed", self, "_on_LevelButton_pressed", [4])

	$Menu/Back.connect("pressed", self, "_on_back_button_pressed")

	var global = get_node("/root/global")
	_on_CharButton_pressed(global.character)
	_on_LevelButton_pressed(global.startLevel)

func _on_back_button_pressed():
	self.queue_free()
	get_tree().change_scene("res://TitleScreen.tscn")

func _clear_all_level_selections():
	$Menu/HBoxLevels/Lev1.self_modulate.a8 = 150
	$Menu/HBoxLevels/Lev2.self_modulate.a8 = 150
	$Menu/HBoxLevels/Lev3.self_modulate.a8 = 150
	$Menu/HBoxLevels/Lev4.self_modulate.a8 = 150

func _on_LevelButton_pressed(level):
	_clear_all_level_selections()
	self.get_node("Menu/HBoxLevels/Lev" + str(level)).self_modulate.a8 = 255
	var global = get_node("/root/global")
	global.startLevel = level
	
func _clear_all_character_selections():
	$Menu/HBoxCharacters/Char1/Button.modulate.a8 = 0
	$Menu/HBoxCharacters/Char3/Button.modulate.a8 = 0
	$Menu/HBoxCharacters/Char4/Button.modulate.a8 = 0
	$Menu/HBoxCharacters/Char5/Button.modulate.a8 = 0

func _on_CharButton_pressed(character):
	_clear_all_character_selections()
	self.get_node("Menu/HBoxCharacters/Char" + str(character) + "/Button").modulate.a8 = 255
	var global = get_node("/root/global")
	global.character = character
