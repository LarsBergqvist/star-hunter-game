extends Node2D

var score = 0
var stars_found = 0
var total_stars = 0
var current_level
var max_health = 100
var health = 100
var current_level_number = 1
var levels_completed = 0
const total_levels = 5

const level_config = { 
	1: { "num_bats": 10, "num_ghosts": 0, "num_bees": 0, "num_flies": 0, "music": "res://sounds/star_hunter.ogg", "volume": 0 },
	2: { "num_bats": 15, "num_ghosts": 0, "num_bees": 0, "num_flies": 0, "music": "res://sounds/star_hunter2.ogg", "volume": 0},
	3: { "num_bats": 10, "num_ghosts": 15, "num_bees": 0, "num_flies": 0, "music": "res://sounds/star_hunter3.ogg", "volume": 0 },
	4: { "num_bats": 0, "num_ghosts": 0, "num_bees": 10, "num_flies": 20, "music": "res://sounds/star_hunter4.ogg", "volume": 0 },
	5: { "num_bats": 10, "num_ghosts": 0, "num_bees": 10, "num_flies": 20, "music": "res://sounds/star_hunter5.ogg", "volume": 8}
	}

func restart_from_current_level():
	_restart_game(current_level_number)


func go_to_title_screen():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	self.queue_free()
	get_tree().paused = false
	get_tree().change_scene("res://title_screen.tscn")


func next_level():
	current_level.queue_free()
	get_tree().paused = false
	current_level_number += 1
	levels_completed += 1
	if current_level_number > total_levels:
		# No more levels for now, restart...
		current_level_number = 1
	_init_level(current_level_number)


func _ready():
	var global = get_node("/root/global")
	current_level_number = global.startLevel
	_init_game_data()
	_init_level(current_level_number)


func _process(_delta):
	if health <= 0:
		global.last_score = score
		get_tree().paused = true
		get_tree().change_scene("res://highscores/gameover.tscn")
		
	if stars_found == total_stars:
		$HUD.show_level_complete_menu()
		get_tree().paused = true


func _init_game_data():
	score = 0
	health = 100
	stars_found = 0
	levels_completed = 0
	global.ammo = global.initial_ammo


func _restart_game(start_level_number):
	current_level.do_physics_process = false
	current_level.queue_free()
	current_level_number = start_level_number
	_init_game_data()
	_init_level(current_level_number)
	get_tree().paused = false
		

func _init_level(level_number):
	_init_level_state()
	
	var levelscene = load("res://level_" + str(level_number) + ".tscn")
	var level = levelscene.instance()
	current_level = level
	
	var config = level_config[level_number];
	var stream = load(config.music)
	$BackgroundMusic.set_stream(stream)
	$BackgroundMusic.volume_db = config.volume
	$BackgroundMusic.play()
	var difficulty_factor = round((levels_completed + 1) / 5) + 1
	level.num_bats = config.num_bats * difficulty_factor
	level.num_ghosts = config.num_ghosts * difficulty_factor
	level.num_bees = config.num_bees * difficulty_factor
	level.num_flies = config.num_flies * difficulty_factor
	
	add_child(level)
	
	$HUD.init()
	
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	
	_update_HUD()
			
	level.connect("star_was_taken", self, "on_star_was_taken")
	level.connect("player_was_hit", self, "on_player_was_hit")
	level.connect("enemy_was_hit", self, "on_enemy_was_hit")
	level.connect("gem_was_taken", self, "on_gem_was_taken")
	level.connect("player_has_bounced_enemy", self, "on_player_has_bounced_enemy")
	level.connect("box_was_opened", self, "on_box_was_opened")


func _init_level_state():
	stars_found = 0
	health = 100


func _update_HUD():
	$HUD.update_HUD(score, total_stars, stars_found, health, max_health, current_level_number)


func on_enemy_was_hit():
	$enemy_hit_sound.play()
	score = score + 5
	_update_HUD()
	

func on_player_has_bounced_enemy(bounce_factor):
	score = score + bounce_factor
	_update_HUD()


func on_player_was_hit():
	health = max(0,health-10)
	_update_HUD()


func on_box_was_opened():
	$unboxing.play()


func on_star_was_taken():
	$ping.play()
	score = score + 10
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	_update_HUD()


func on_gem_was_taken(gemType):
	$ping.play()
	if gemType == GemType.HEART:
		health = min(100,health+10)
	elif gemType == GemType.DIAMOND:
		score = score + 5
	elif gemType == GemType.ORB:
		global.ammo = global.ammo + 1
	_update_HUD()
