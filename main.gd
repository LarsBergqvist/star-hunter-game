extends Node2D

var score = 0
var stars_found = 0
var total_stars = 0
var current_level

func _ready():
	var levelscene = load("res://Level_1.tscn")
	var level = levelscene.instance()
	current_level = level
	add_child(level)
	
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = total_stars - stars_found
	$HUD/GUI.total_stars = total_stars
	$HUD/GUI.stars_found = stars_found
	
	level.connect("star_was_taken", self, "on_star_was_taken")

	pass

func on_star_was_taken():
	score = score + 10
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = total_stars - stars_found
	$HUD/GUI.total_stars = total_stars
	$HUD/GUI.stars_found = stars_found
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
