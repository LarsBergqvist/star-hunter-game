extends Node2D

signal star_was_taken
signal player_was_hit
signal enemy_was_hit
signal gem_was_taken
signal player_has_bounced_enemy
signal box_was_opened

var total_stars = 0
var stars_found = 0
var num_bats = 0
var num_ghosts = 0
var num_bees = 0
var num_flies = 0
var do_physics_process = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	do_physics_process = true
	var pos_curve = $ItemPositions.get_curve()
	total_stars = pos_curve.get_point_count()
	for i in range(0, total_stars):
		var star = preload("res://items/star.tscn").instance()
		add_child(star)
		star.position = pos_curve.get_point_position(i)
		star.connect("star_taken", self, "on_star_taken")

	if get_node_or_null("BatPath") != null:
		for _i in range(0,num_bats):
			var bat = preload("res://enemies/bat.tscn").instance()
			bat.path = $BatPath/PathFollow2D
			bat.bounce_factor = 2
			bat.connect("player_hit", self, "on_player_hit")
			bat.connect("enemy_hit", self, "on_enemy_hit")
			bat.connect("player_bounced_enemy", self, "on_player_bounced_enemy")
			add_child(bat)

	if get_node_or_null("GhostPath") != null:
		for _i in range(0,num_ghosts):
			var ghost = preload("res://enemies/ghost.tscn").instance()
			ghost.bounce_factor = 4
			ghost.path = $GhostPath/PathFollow2D
			ghost.connect("player_hit", self, "on_player_hit")
			ghost.connect("enemy_hit", self, "on_enemy_hit")
			ghost.connect("player_bounced_enemy", self, "on_player_bounced_enemy")
			add_child(ghost)

	if get_node_or_null("BeePath") != null:
		for _i in range(0,num_bees):
			var bee = preload("res://enemies/bee.tscn").instance()
			bee.bounce_factor = 3
			bee.path = $BeePath/PathFollow2D
			bee.connect("player_hit", self, "on_player_hit")
			bee.connect("enemy_hit", self, "on_enemy_hit")
			bee.connect("player_bounced_enemy", self, "on_player_bounced_enemy")
			add_child(bee)

	if get_node_or_null("FlyPath") != null:
		for _i in range(0,num_flies):
			var fly = preload("res://enemies/fly.tscn").instance()
			fly.bounce_factor = 4
			fly.path = $FlyPath/PathFollow2D
			fly.connect("player_hit", self, "on_player_hit")
			fly.connect("enemy_hit", self, "on_enemy_hit")
			fly.connect("player_bounced_enemy", self, "on_player_bounced_enemy")
			add_child(fly)

	$player.connect("box_opened", self, "on_box_opened")

func on_box_opened(_player_pos, tile_pos):
	emit_signal("box_was_opened")
	if (rng.randf_range(0, 1) > 0.6):
		var gem = preload("res://items/gem.tscn").instance()
		gem.position = $TileMap.map_to_world(tile_pos)
		gem.position.x += 35
		gem.position.y += 35
		gem.connect("gem_taken", self, "on_gem_taken")
		add_child(gem)

func on_gem_taken(gemType):
	emit_signal("gem_was_taken", gemType)


func _physics_process(_delta):
	if not do_physics_process:
		return
		
	if $player.position.y > 1500:
		emit_signal("player_was_hit")


func on_player_hit():
	emit_signal("player_was_hit")


func on_star_taken():
	stars_found += 1
	emit_signal("star_was_taken")

func on_player_bounced_enemy(bounce_factor):
	emit_signal("player_has_bounced_enemy", bounce_factor)
	
func on_enemy_hit():
	emit_signal("enemy_was_hit")

