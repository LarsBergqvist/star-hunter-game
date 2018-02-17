extends Node2D

export (PackedScene) var Star
export (PackedScene) var Bat

signal star_was_taken
signal player_was_hit
signal enemy_was_hit

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

	for i in range(0,10):
		var bat = Bat.instance()
		bat.path = $BatPath/PathFollow2D
		bat.connect("player_hit", self, "on_player_hit")
		bat.connect("enemy_hit", self, "on_enemy_hit")
		add_child(bat)

	$bg_music.play()

func _physics_process(delta):
	if $player.position.y > 1000:
		emit_signal("player_was_hit")
		
	
func on_player_hit():
	$player.was_hit = true
	emit_signal("player_was_hit")
	
func on_star_taken():
	stars_found += 1
	emit_signal("star_was_taken")
	
func on_enemy_hit():
	emit_signal("enemy_was_hit")

