extends Control

func _ready():
	if global.last_score == 0 or global.apikey.length() == 0 or global.highscore_api.length() == 0:
		go_to_title_screen()
		return
		
	$PanelContainer/VBox/HBox1/Score.text = str(global.last_score)
	$PanelContainer/VBox/Entername.connect("to_title_screen", self, "go_to_title_screen")
	
	
func go_to_title_screen():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	self.queue_free()
	get_tree().paused = false
	get_tree().change_scene("res://title_screen.tscn")
