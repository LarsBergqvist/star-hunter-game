extends Node2D

var score = 0
var stars_found = 0
var total_stars = 0
var current_level
var max_health = 100
var health = 100
var balls = 8
var current_level_number = 1
const total_levels = 5
var gamePadLeft = null
var jumpButton = null

const level_config = { 
	1: { "num_bats": 10, "num_ghosts": 0, "num_bees": 0, "num_flies": 0 },
	2: { "num_bats": 15, "num_ghosts": 0, "num_bees": 0, "num_flies": 0  },
	3: { "num_bats": 5, "num_ghosts": 15, "num_bees": 0, "num_flies": 0  },
	4: { "num_bats": 0, "num_ghosts": 0, "num_bees": 10, "num_flies": 20  },
	5: { "num_bats": 10, "num_ghosts": 0, "num_bees": 10, "num_flies": 20  }
	}

			
func _ready():
	var global = get_node("/root/global")
	current_level_number = global.startLevel
	init_level(current_level_number)

func _process(_delta):
	if Input.is_action_pressed("pause"):
		show_game_paused_menu()
		get_tree().paused = true
		
	if health <= 0:
		show_game_over_menu()
		get_tree().paused = true
		
	if stars_found == total_stars:
		show_level_complete_menu()
#		if (current_level_number == total_levels):
#			show_game_complete_menu()
#		else:
#			show_level_complete_menu()
		get_tree().paused = true


func restart_game(start_level_number):
	current_level.do_physics_process = false
	current_level.queue_free()
	current_level_number = start_level_number
	score = 0
	health = 100
	stars_found = 0
	init_level(current_level_number)
	init_game_state()
	get_tree().paused = false
	
func _on_PlayAgainButton_pressed():
	restart_game(1)

func next_level():
	current_level.queue_free()
	get_tree().paused = false
	current_level_number += 1
	if current_level_number > total_levels:
		# No more levels for now, restart...
		current_level_number = 1
	init_level(current_level_number)
	
func init_level(level_number):
	init_game_state()
	
	var levelscene = load("res://Level_" + str(level_number) + ".tscn")
	var level = levelscene.instance()
	current_level = level
	level.num_bats = level_config[level_number].num_bats
	level.num_ghosts = level_config[level_number].num_ghosts
	level.num_bees = level_config[level_number].num_bees
	level.num_flies = level_config[level_number].num_flies
	
	add_child(level)
	
	_add_game_buttons()
	
	init_from_current_level()
	
	update_HUD()
			
	level.connect("star_was_taken", self, "on_star_was_taken")
	level.connect("player_was_hit", self, "on_player_was_hit")
	level.connect("enemy_was_hit", self, "on_enemy_was_hit")
	level.connect("gem_was_taken", self, "on_gem_was_taken")

func _on_GoToNextLevel_pressed():
	next_level()

func init_from_current_level():
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found

func init_game_state():
	stars_found = 0
	total_stars = 1000
	max_health = 100
	health = 100

func update_HUD():
	$HUD/GUI.score = score
	$HUD/GUI.stars_remaining = total_stars - stars_found
	$HUD/GUI.total_stars = total_stars
	$HUD/GUI.stars_found = stars_found
	$HUD/GUI.health = health
	$HUD/GUI.max_health = max_health
	$HUD/GUI.level = current_level_number
	$HUD/GUI.balls = balls

func on_enemy_was_hit():
	$enemy_hit_sound.play()
	score = score + 5
	update_HUD()
	
func on_player_was_hit():
	health = max(0,health-10)
	update_HUD()

func on_star_was_taken():
	$ping.play()
	score = score + 10
	total_stars = current_level.total_stars
	stars_found = current_level.stars_found
	update_HUD()

func on_gem_was_taken(gemType):
	$ping.play()
	if gemType == GemType.Heart:
		health = min(100,health+10)
	elif gemType == GemType.Diamond:
		score = score + 5
	elif gemType == GemType.Ball:
		global.balls = global.balls + 1
	update_HUD()


const RESUME_GAME = 1
const START_NEW_GAME = 2
const GO_TO_NEXT_LEVEL = 4
const REPLAY_FROM_CURRENT_LEVEL = 5

func show_game_paused_menu():
	$HUD/Message.text = "Game paused"
	$HUD/Message.show()
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Resume game", RESUME_GAME)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()

func show_game_over_menu():
	$HUD/Message.text = "Game over..."
	$HUD/Message.show()
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()

func show_level_complete_menu():
	$HUD/Message.text = "Level complete!"
	$HUD/Message.show()
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Go to next level", GO_TO_NEXT_LEVEL)
	$HUD/VBox/Menu.add_item("Replay level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()

func show_game_complete_menu():
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
	get_tree().change_scene("res://TitleScreen.tscn")

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
		restart_game(current_level_number)
		$HUD/Message.hide()
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()
	elif ID == GO_TO_NEXT_LEVEL:
		next_level()
		$HUD/Message.hide()
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()

	pass # replace with function body

func _add_game_buttons():
	var hud = get_node("HUD")

	if (gamePadLeft != null):
		hud.remove_child(gamePadLeft)
	var gamePadLeftScene = load("res://GamePadLeft.tscn")
	gamePadLeft = gamePadLeftScene.instance()
	hud.add_child(gamePadLeft)

	if (jumpButton != null):
		hud.remove_child(jumpButton)
	var jumpButtonScene = load("res://JumpButton.tscn")
	jumpButton = jumpButtonScene.instance()
	hud.add_child(jumpButton)

func _on_Pause_pressed():
	pass # Replace with function body.
