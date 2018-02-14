extends MarginContainer

export (int) var score = 0
export (int) var stars_remaining = 0


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	$HBoxContainer/VSplitContainer/Score.text = "Score: " + str(score)
	$HBoxContainer/VSplitContainer/Stars.text = "Stars remaining: " + str(stars_remaining)