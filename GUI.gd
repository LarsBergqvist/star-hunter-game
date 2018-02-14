extends MarginContainer

export (int) var score = 0
export (int) var stars_remaining = 0
export (int) var total_stars = 0
export (int) var stars_found = 0


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	$HBox/VSplit/Score.text = "Score: " + str(score)
	$HBox/VSplit/VSplit/ProgressBar.max_value = total_stars
	$HBox/VSplit/VSplit/ProgressBar.value = stars_found
