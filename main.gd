extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var score = 0

var current_level

func _ready():
	var levelscene = load("res://Level_1.tscn")
	var level = levelscene.instance()
	current_level = level
	add_child(level)
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = current_level.stars_remaining
	level.connect("increase_score", self, "on_increase_score")

	# Called every time the node is added to the scene.
	# Initialization here
	pass

func on_increase_score():
	score = score + 10
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = current_level.stars_remaining
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
