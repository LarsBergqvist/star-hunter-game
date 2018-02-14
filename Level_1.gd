extends Node2D

export (PackedScene) var Star

signal increase_score

export (int) var stars_remaining

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var pos_curve = $ItemPositions.get_curve()
	var num_stars = pos_curve.get_point_count()
	stars_remaining = num_stars
	for i in range(0, num_stars):
		var star = Star.instance()
		add_child(star)
		star.position = pos_curve.get_point_position(i)
		star.connect("star_taken", self, "on_star_taken")

func on_star_taken():
	stars_remaining -= 1
	emit_signal("increase_score")

