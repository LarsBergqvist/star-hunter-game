extends Node2D

export (PackedScene) var Star

signal star_was_taken

export (int) var total_stars = 0
export (int) var stars_found = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var pos_curve = $ItemPositions.get_curve()
	total_stars = pos_curve.get_point_count()
	for i in range(0, total_stars):
		var star = Star.instance()
		add_child(star)
		star.position = pos_curve.get_point_position(i)
		star.connect("star_taken", self, "on_star_taken")

func on_star_taken():
	stars_found += 1
	emit_signal("star_was_taken")

