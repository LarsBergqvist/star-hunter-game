extends MarginContainer

var score = 0
var stars_remaining = 0
var total_stars = 0
var stars_found = 0
var max_health = 0
var health = 0
var level = 1


func _process(_delta):
	$Grid/Score.text = str(score)
	$Grid/Level.text = str(level)
	$Grid/LevelComplete.max_value = total_stars
	$Grid/LevelComplete.value = stars_found
	$Grid/Health.max_value = max_health
	$Grid/Health.value = health
	var global = get_node("/root/global")
	$Grid/Ammo.text = str(global.ammo)
