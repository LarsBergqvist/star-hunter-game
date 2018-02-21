extends Node2D

export (PackedScene) var Star
export (PackedScene) var Bat
export (PackedScene) var Gem
export (PackedScene) var Ghost
export (PackedScene) var Bee
export (PackedScene) var Fly

signal star_was_taken
signal player_was_hit
signal enemy_was_hit
signal gem_was_taken

export (int) var total_stars = 0
export (int) var stars_found = 0
export (int) var num_bats = 0
export (int) var num_ghosts = 0
export (int) var num_bees = 0
export (int) var num_flies = 0

export (bool) var do_physics_process = false
func _ready():
	do_physics_process = true
	var pos_curve = $ItemPositions.get_curve()
	total_stars = pos_curve.get_point_count()
	for i in range(0, total_stars):
		var star = Star.instance()
		add_child(star)
		star.position = pos_curve.get_point_position(i)
		star.connect("star_taken", self, "on_star_taken")

	if not $BatPath == null:
		for i in range(0,num_bats):
			var bat = Bat.instance()
			bat.path = $BatPath/PathFollow2D
			bat.connect("player_hit", self, "on_player_hit")
			bat.connect("enemy_hit", self, "on_enemy_hit")
			add_child(bat)

	if not $GhostPath == null:
		for i in range(0,num_ghosts):
			var ghost = Ghost.instance()
			ghost.path = $GhostPath/PathFollow2D
			ghost.connect("player_hit", self, "on_player_hit")
			ghost.connect("enemy_hit", self, "on_enemy_hit")
			add_child(ghost)

	if not $BeePath == null:
		for i in range(0,num_bees):
			var bee = Bee.instance()
			bee.path = $BeePath/PathFollow2D
			bee.connect("player_hit", self, "on_player_hit")
			bee.connect("enemy_hit", self, "on_enemy_hit")
			add_child(bee)

	if not $FlyPath == null:
		for i in range(0,num_flies):
			var fly = Fly.instance()
			fly.path = $FlyPath/PathFollow2D
			fly.connect("player_hit", self, "on_player_hit")
			fly.connect("enemy_hit", self, "on_enemy_hit")
			add_child(fly)

	$player.connect("box_opened", self, "on_box_opened")
	
	$bg_music.play()

func on_box_opened(player_pos, tile_pos):
	var gem = Gem.instance()
	gem.position = $TileMap.map_to_world(tile_pos)
	gem.position.x += 35
	gem.position.y += 35
	gem.connect("gem_taken", self, "on_gem_taken")
	add_child(gem)

func on_gem_taken():
	emit_signal("gem_was_taken")

func _physics_process(delta):
	if not do_physics_process:
		return
		
	if $player.position.y > 1500:
		$player.was_hit = true
		emit_signal("player_was_hit")
		
func on_player_hit():
	$player.was_hit = true
	emit_signal("player_was_hit")
	
func on_star_taken():
	stars_found += 1
	emit_signal("star_was_taken")
	
func on_enemy_hit():
	emit_signal("enemy_was_hit")

