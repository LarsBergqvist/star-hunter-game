extends Node2D

var score = 0
var stars_found = 0
var total_stars = 0
var current_level
var max_health = 100
var health = 100
var current_level_number = 1
const total_levels = 5
var gamePadLeft = null
var actionButtons = null

const level_config = { 
	1: { "num_bats": 10, "num_ghosts": 0, "num_bees": 0, "num_flies": 0, "music": "res://sounds/star_hunter.ogg" },
	2: { "num_bats": 15, "num_ghosts": 0, "num_bees": 0, "num_flies": 0, "music": "res://sounds/star_hunter2.ogg" },
	3: { "num_bats": 5, "num_ghosts": 15, "num_bees": 0, "num_flies": 0, "music": "res://sounds/star_hunter3.ogg" },
	4: { "num_bats": 0, "num_ghosts": 0, "num_bees": 10, "num_flies": 20, "music": "res://sounds/star_hunter4.ogg"  },
	5: { "num_bats": 10, "num_ghosts": 0, "num_bees": 10, "num_flies": 20, "music": "res://sounds/star_hunter2.ogg"}
	}

			
func _ready():
	var global = get_node("/root/global")
	current_level_number = global.startLevel
	_init_game_data()
	init_level(current_level_number)


func _process(_delta):
	if Input.is_action_pressed("pause"):
		_show_game_paused_menu()
		get_tree().paused = true
		
	if health <= 0:
		_show_game_over_menu()
		get_tree().paused = true
		
	if stars_found == total_stars:
		_show_level_complete_menu()
#		if (current_level_number == total_levels):
#			show_game_complete_menu()
#		else:
#			show_level_complete_menu()
		get_tree().paused = true


func _init_game_data():
	score = 0
	health = 100
	stars_found = 0
	global.ammo = global.initial_ammo


func _restart_game(start_level_number):
	current_level.do_physics_process = false
	current_level.queue_free()
	current_level_number = start_level_number
	_init_game_data()
	init_level(current_level_number)
	get_tree().paused = false
	

func _on_PlayAgainButton_pressed():
	_restart_game(1)


func _next_level():
	current_level.queue_free()
	get_tree().paused = false
	current_level_number += 1
	if current_level_number > total_levels:
		# No more levels for now, restart...
		current_level_number = 1
	init_level(current_level_number)
	

func init_level(level_number):
	_init_level_state()
	
	var levelscene = load("res://level_" + str(level_number) + ".tscn")
	var level = levelscene.instance()
	current_level = level
	
	var config = level_config[level_number];
	var stream = load(config.music)
	$BackgroundMusic.set_stream(stream)
	$BackgroundMusic.play()
	level.num_bats = config.num_bats
	level.num_ghosts = config.num_ghosts
	level.num_bees = config.num_bees
	level.num_flies = config.num_flies
	
	add_child(level)
	
	_add_game_buttons()
	
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	
	_update_HUD()
			
	level.connect("star_was_taken", self, "on_star_was_taken")
	level.connect("player_was_hit", self, "on_player_was_hit")
	level.connect("enemy_was_hit", self, "on_enemy_was_hit")
	level.connect("gem_was_taken", self, "on_gem_was_taken")


func _on_GoToNextLevel_pressed():
	_next_level()


func _init_level_state():
	stars_found = 0
	health = 100


func _update_HUD():
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = total_stars - stars_found
	$HUD/GUI.total_stars = total_stars
	$HUD/GUI.stars_found = stars_found
	$HUD/GUI.health = health
	$HUD/GUI.max_health = max_health
	$HUD/GUI.level = current_level_number


func on_enemy_was_hit():
	$enemy_hit_sound.play()
	score = score + 5
	_update_HUD()
	

func on_player_was_hit():
	health = max(0,health-10)
	_update_HUD()


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


const RESUME_GAME = 1
const START_NEW_GAME = 2
const GO_TO_NEXT_LEVEL = 4
const REPLAY_FROM_CURRENT_LEVEL = 5

func _show_game_paused_menu():
	$HUD/Message.text = "Game paused"
	$HUD/Message.show()
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Resume game", RESUME_GAME)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()


func _show_game_over_menu():
	$HUD/Message.text = "Game over..."
	$HUD/Message.show()
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()


func _show_level_complete_menu():
	$HUD/Message.text = "Level complete!"
	$HUD/Message.show()
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Go to next level", GO_TO_NEXT_LEVEL)
	$HUD/VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()


func _show_game_complete_menu():
	$HUD/Message.text = "Game complete!!!"
	$HUD/Message.show()
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()


func _go_to_title_screen():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	self.queue_free()
	get_tree().paused = false
	get_tree().change_scene("res://title_screen.tscn")

func _on_Menu_id_pressed( ID ):
	if ID == RESUME_GAME:
		get_tree().paused = false
		$HUD/VBox/Menu.hide()
		$HUD/Message.hide()
		$HUD/VBox.hide()
	elif ID == START_NEW_GAME:
		_go_to_title_screen()
#		restart_game(1)
#		$HUD/Message.hide()
#		$HUD/VBox/Menu.hide()
#		$HUD/VBox.hide()
	elif ID == REPLAY_FROM_CURRENT_LEVEL:
		_restart_game(current_level_number)
		$HUD/Message.hide()
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()
	elif ID == GO_TO_NEXT_LEVEL:
		_next_level()
		$HUD/Message.hide()
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()

	pass # replace with function body


func _add_game_buttons():
	var hud = get_node("HUD")

	if (gamePadLeft != null):
		hud.remove_child(gamePadLeft)
	var gamePadLeftScene = load("res://gamepad_left.tscn")
	gamePadLeft = gamePadLeftScene.instance()
	hud.add_child(gamePadLeft)

	if (actionButtons != null):
		hud.remove_child(actionButtons)
	var actionButtonsScene = load("res://action_buttons.tscn")
	actionButtons = actionButtonsScene.instance()
	hud.add_child(actionButtons)
