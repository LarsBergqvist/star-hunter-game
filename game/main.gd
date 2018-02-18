extends Node2D

var score = 0
var stars_found = 0
var total_stars = 0
var current_level
var max_health = 100
var health = 100
var current_level_number = 3
const total_levels = 3

func init():
	stars_found = 0
	total_stars = 0
	max_health = 100
	health = 100
	$Messages/GameOver.hide()
	$Messages/LevelComplete.hide()
	$Messages/PlayAgain.hide()
	$Messages/GoToNextLevel.hide()
	$Messages/GameComplete.hide()

func init2():
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = total_stars - stars_found
	$HUD/GUI.total_stars = total_stars
	$HUD/GUI.stars_found = stars_found
	$HUD/GUI.health = health
	$HUD/GUI.max_health = max_health
	$HUD/GUI.level = current_level_number
		
func init_from_current_level():
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	
func _ready():
	init_level(current_level_number)

func on_enemy_was_hit():
	$enemy_hit_sound.play()
	score = score + 5
	$HUD/GUI.score = score
	
func on_player_was_hit():
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

func on_gem_was_taken():
	$ping.play()
	score = score + 5
	$HUD/GUI.score = score
	
func _process(delta):
	if health <= 0:
		$Messages/GameOver.show()
		$Messages/PlayAgain.show()
		get_tree().paused = true
		
	if stars_found == total_stars:
		if (current_level_number == total_levels):
			$Messages/GameComplete.show()
			$Messages/PlayAgain.show()
		else:
			$Messages/LevelComplete.show()
			$Messages/GoToNextLevel.show()
		get_tree().paused = true


func _on_PlayAgainButton_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false
	init()

func next_level():
	current_level.queue_free()
	get_tree().paused = false
	current_level_number += 1
	init_level(current_level_number)
	
func init_level(level_number):
	init()
	
	var levelscene = load("res://Level_" + str(level_number) + ".tscn")
	var level = levelscene.instance()
	current_level = level
	add_child(level)
	
	init_from_current_level()
	
	init2()
		
	level.connect("star_was_taken", self, "on_star_was_taken")

	level.connect("player_was_hit", self, "on_player_was_hit")
	level.connect("enemy_was_hit", self, "on_enemy_was_hit")
	level.connect("gem_was_taken", self, "on_gem_was_taken")

func _on_GoToNextLevel_pressed():
	next_level()
