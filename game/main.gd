extends Node2D

var score = 0
var stars_found = 0
var total_stars = 0
var current_level
var max_health = 100
var health = 100
var current_level_number = 1
const total_levels = 4

const level_config = { 
	1: { "num_bats": 10, "num_ghosts": 0, "num_bees": 0, "num_flies": 0 },
	2: { "num_bats": 15, "num_ghosts": 0, "num_bees": 0, "num_flies": 0  },
	3: { "num_bats": 5, "num_ghosts": 15, "num_bees": 0, "num_flies": 0  },
	4: { "num_bats": 0, "num_ghosts": 0, "num_bees": 10, "num_flies": 20  }
	}

			
func _ready():
	init_level(current_level_number)

func _process(delta):
	if Input.is_action_pressed("pause"):
		show_game_paused_menu()
		get_tree().paused = true
		
	if health <= 0:
		show_game_over_menu()
		get_tree().paused = true
		
	if stars_found == total_stars:
		if (current_level_number == total_levels):
			show_game_complete_menu()
		else:
			show_level_complete_menu()
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
	restart_game()

func next_level():
	current_level.queue_free()
	get_tree().paused = false
	current_level_number += 1
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

func on_gem_was_taken():
	$ping.play()
	score = score + 5
	update_HUD()


const RESUME_GAME = 1
const START_NEW_GAME = 2
const QUIT_GAME = 3
const GO_TO_NEXT_LEVEL = 4
const REPLAY_FROM_CURRENT_LEVEL = 5

func show_game_paused_menu():
	$HUD/VBox/Message.text = "Game paused"
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Resume game", RESUME_GAME)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.add_item("Quit game", QUIT_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()

func show_game_over_menu():
	$HUD/VBox/Message.text = "Game over..."
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Replay from current level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.add_item("Quit game", QUIT_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()

func show_level_complete_menu():
	$HUD/VBox/Message.text = "Level complete!"
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Go to next level", GO_TO_NEXT_LEVEL)
	$HUD/VBox/Menu.add_item("Replay from current level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.add_item("Quit game", QUIT_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()

func show_game_complete_menu():
	$HUD/VBox/Message.text = "Game complete!!!"
	$HUD/VBox/Menu.clear()
	$HUD/VBox/Menu.add_item("Replay from current level", REPLAY_FROM_CURRENT_LEVEL)	
	$HUD/VBox/Menu.add_item("Start a new game", START_NEW_GAME)
	$HUD/VBox/Menu.add_item("Quit game", QUIT_GAME)
	$HUD/VBox/Menu.popup()
	$HUD/VBox.show()

func _on_Menu_id_pressed( ID ):
	if ID == RESUME_GAME:
		get_tree().paused = false
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()
	elif ID == QUIT_GAME:
		get_tree().quit()
	elif ID == START_NEW_GAME:
		restart_game(1)
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()
	elif ID == REPLAY_FROM_CURRENT_LEVEL:
		restart_game(current_level_number)
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()
	elif ID == GO_TO_NEXT_LEVEL:
		next_level()
		$HUD/VBox/Menu.hide()
		$HUD/VBox.hide()

	pass # replace with function body
