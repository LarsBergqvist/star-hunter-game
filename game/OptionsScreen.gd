extends Control

const num_characters = 4
const num_levels = 4

func _ready():
	for character in range(1, num_characters + 1):
		var node = self.get_node("Menu/HBoxCharacters/Char" + str(character) + "/Button")
		node.connect("pressed", self, "_on_CharButton_pressed", [character])

	for level in range(1, num_levels + 1):
		var node = self.get_node("Menu/HBoxLevels/Lev" + str(level))
		node.connect("pressed", self, "_on_LevelButton_pressed", [level])
		
	$Menu/Back.connect("pressed", self, "_on_back_button_pressed")

	var global = get_node("/root/global")
	_on_CharButton_pressed(global.character)
	_on_LevelButton_pressed(global.startLevel)

func _on_back_button_pressed():
	self.queue_free()
	get_tree().change_scene("res://TitleScreen.tscn")

func _clear_all_level_selections():
	for level in range(1, num_levels + 1):
		self.get_node("Menu/HBoxLevels/Lev" + str(level)).self_modulate.a8 = 150

func _on_LevelButton_pressed(level):
	_clear_all_level_selections()
	self.get_node("Menu/HBoxLevels/Lev" + str(level)).self_modulate.a8 = 255
	var global = get_node("/root/global")
	global.startLevel = level
	
func _clear_all_character_selections():
	for n in range(1, num_characters + 1):
		self.get_node("Menu/HBoxCharacters/Char" + str(n) + "/Button").modulate.a8 = 0

func _on_CharButton_pressed(character):
	_clear_all_character_selections()
	self.get_node("Menu/HBoxCharacters/Char" + str(character) + "/Button").modulate.a8 = 255
	var global = get_node("/root/global")
	global.character = character
