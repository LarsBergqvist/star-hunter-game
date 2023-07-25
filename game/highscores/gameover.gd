extends Control

func _ready():
	$PanelContainer/VBox/HBox1/Score.text = str(global.last_score)
	
	
func go_to_title_screen():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	self.queue_free()
	get_tree().paused = false
	get_tree().change_scene("res://title_screen.tscn")
