extends Node2D

export (PackedScene) var Star

signal increase_score

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var pos_curve = $ItemPositions.get_curve()
	var num_pos = pos_curve.get_point_count()
	for i in range(0, num_pos):
		var star = Star.instance()
		add_child(star)
		star.position = pos_curve.get_point_position(i)
		star.connect("star_taken", self, "on_star_taken")

func on_star_taken():
	emit_signal("increase_score")

