extends Node2D

var score = 0
var stars_found = 0
var total_stars = 0
var current_level
var max_health = 100
var health = 100


func _ready():
	$Messages/GameOver.hide()
	$Messages/LevelComplete.hide()
	
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

	$HUD/GUI.health = health
	$HUD/GUI.max_health = max_health

	level.connect("player_was_hit", self, "on_player_was_hit")

func on_player_was_hit():
#	$ping.play()
	health = max(0,health-10)
	$HUD/GUI.health = health
	$HUD/GUI.max_health = max_health
	
func on_star_was_taken():
	$ping.play()
	score = score + 10
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = total_stars - stars_found
	$HUD/GUI.total_stars = total_stars
	$HUD/GUI.stars_found = stars_found
	
func _process(delta):
	if health <= 0:
		$Messages/GameOver.show()
		get_tree().paused = true
		
	if stars_found == total_stars:
		$Messages/LevelComplete.show()
		get_tree().paused = true
