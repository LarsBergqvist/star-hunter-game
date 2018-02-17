extends MarginContainer

export (int) var score = 0
export (int) var stars_remaining = 0
export (int) var total_stars = 0
export (int) var stars_found = 0
export (int) var max_health = 0
export (int) var health = 0
export (int) var level = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	$HBox/VSplit/HSplit2/Score.text = "Score: " + str(score)
	$HBox/VSplit/HSplit2/Level.text = "Level: " + str(level)
	$HBox/VSplit/HSplit/VSplitL/LevelComplete.max_value = total_stars
	$HBox/VSplit/HSplit/VSplitL/LevelComplete.value = stars_found
	$HBox/VSplit/HSplit/VSplitR/Health.max_value = max_health
	$HBox/VSplit/HSplit/VSplitR/Health.value = health
