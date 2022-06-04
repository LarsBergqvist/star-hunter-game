extends MarginContainer

export (int) var score = 0
export (int) var stars_remaining = 0
export (int) var total_stars = 0
export (int) var stars_found = 0
export (int) var max_health = 0
export (int) var health = 0
export (int) var level = 1
export (int) var balls = 10

func _ready():
	pass

func _process(_delta):
	$Grid/Score.text = str(score)
	$Grid/Level.text = str(level)
	$Grid/LevelComplete.max_value = total_stars
	$Grid/LevelComplete.value = stars_found
	$Grid/Health.max_value = max_health
	$Grid/Health.value = health
	var global = get_node("/root/global")
	$Grid/Balls.text = str(global.balls)
