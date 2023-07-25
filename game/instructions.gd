extends Control


onready var _transition_rect := $SceneTransitionRect


func _ready():
	$Back.connect("pressed", self, "_on_back_button_pressed")
	

func _on_back_button_pressed():
	_transition_rect.transition_to("res://title_screen.tscn", self)
