extends KinematicBody2D
class_name Player

export (bool) var is_player = true

signal box_opened

const GRAVITY = 1000.0 # pixels/second/second

const WALK_FORCE = 600
const WALK_MIN_SPEED = 1 # 10
const WALK_MAX_SPEED = 300 # 200
const STOP_FORCE = 1300
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME = 0.2
const CLIMB_SPEED = 3

var playerState = PlayerState.new()


func get_velocity():
	return playerState.velocity


func _ready()->void:
	var global = get_node("/root/global")
	playerState.characterId = global.character
	$PlayerSprite.animate_stop(playerState.characterId)
	var parent = get_parent()
	if (parent != null):
		parent.connect("gem_was_taken", self, "on_gem_was_taken")
		parent.connect("star_was_taken", self, "on_star_was_taken")
		parent.connect("enemy_was_hit", self, "on_enemy_was_hit")
		parent.connect("player_was_hit", self, "on_player_was_hit")

		
func _physics_process(delta: float)->void:
	if playerState.is_hit:
		_handle_hit_player()
		return
	else:
		$PlayerSprite.stop_animating_hit()
	
	playerState.on_ladder = _get_tile_on_position(position.x, position.y+35) == "ladder"
	_check_collision_with_box()
			
	var cmd: Commands.CommandStates = Commands.get_commands(playerState)

	_handle_idle_timer(cmd)
	
	_apply_movement(cmd, delta)	
		
	_animate_sprite(cmd)


func _handle_hit_player()->void:
	$PlayerSprite.animate_hit_player(playerState)
	if $RecoverTimer.is_stopped():
		$RecoverTimer.start()
		_play_hit_sound()


func _player_makes_sound()->bool:
	return $ooooh.playing or $jippee.playing or $hmmm.playing or $ehhh.playing


func _handle_idle_timer(cmd: Commands.CommandStates)->void:
	var active = Commands.is_active(cmd)
	if active or playerState.on_ladder:
		$WaitAfterIdle.stop()
	else:
		if $WaitAfterIdle.is_stopped():
			$WaitAfterIdle.start()
		
	
func _apply_movement(cmd: Commands.CommandStates, delta: float)->void:
	var force = Vector2(0, GRAVITY)
	force = _get_horizontal_force(cmd.walk_left, cmd.walk_right, force, delta)
	playerState.velocity += force * delta	
	
	if playerState.on_ladder:
		_handle_ladder_movements(cmd.climb_up, cmd.climb_down)
	else:
		playerState.velocity = move_and_slide(playerState.velocity, Vector2(0, -1), false, 4,0.9,true)

	_handle_jumping(playerState.on_ladder, cmd.jump, delta)
	
	
func _handle_jumping(on_ladder: bool, jump: bool, delta)->void:
	if is_on_floor() or on_ladder:
		playerState.total_air_time = 0
	else:
		playerState.total_air_time += delta
		
	if playerState.is_jump_state and playerState.velocity.y >= 0:
		# If falling, no longer jumping
		playerState.is_jump_state = false
	
	if playerState.total_air_time < JUMP_MAX_AIRBORNE_TIME and jump and !playerState.is_jump_state:
		# Jump must also be allowed to happen if the character left the floor a little while ago.
		# Makes controls more snappy.
		playerState.velocity.y = -JUMP_SPEED
		playerState.is_jump_state = true

	
func _handle_ladder_movements(climb_up: bool, climb_down: bool)->void:
	if climb_up:
		var pos = get_position()
		pos.y = pos.y - CLIMB_SPEED
		set_position(pos)
	elif climb_down and not is_on_floor():
		var pos = get_position()
		pos.y = pos.y + CLIMB_SPEED
		set_position(pos)
	elif !playerState.is_jump_state:
		var v = playerState.velocity
		v.y = 0
		playerState.velocity = move_and_slide(v, Vector2(0, 0))
	else:
		playerState.velocity = move_and_slide(playerState.velocity, Vector2(0, -1))

	
func _get_horizontal_force(walk_left: bool, walk_right: bool, force: Vector2, delta: float)->Vector2:
	var stop = true
	
	if walk_left:
		if playerState.velocity.x <= WALK_MIN_SPEED and playerState.velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if playerState.velocity.x >= -WALK_MIN_SPEED and playerState.velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(playerState.velocity.x)
		var vlen = abs(playerState.velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		playerState.velocity.x = vlen * vsign

	return force


func _animate_sprite(cmd: Commands.CommandStates)->void:
	$PlayerSprite.animate(cmd, playerState)
	
	if !Commands.is_active(cmd) and _player_makes_sound():
		$PlayerSprite.animate_talking(playerState.characterId)

	if ($PlayerSprite.is_animating_ducking(playerState.characterId)):
		$CollisionPolygon2D.disabled = true
		$CollisionPolygon2DDuck.disabled = false
	else:
		$CollisionPolygon2D.disabled = false
		$CollisionPolygon2DDuck.disabled = true		


func _on_WaitAfterIdle_timeout()->void:
	$PlayerSprite.show_emote("question", 2)
	$WaitAfterIdle.stop()
	_play_idle_sound()


func _on_RecoverTimer_timeout()->void:
	playerState.is_hit = false
	$RecoverTimer.stop()


func on_gem_was_taken()->void:
	$PlayerSprite.show_emote("money", 0.5)

	
func on_star_was_taken()->void:
	$PlayerSprite.show_emote("star", 0.5)


func on_player_was_hit()->void:
	playerState.is_hit = true


func on_enemy_was_hit()->void:
	$PlayerSprite.show_emote("haha", 0.5)


const idle_sounds = ["ooooh","jippee","hmmm","ehhh"]
func _play_idle_sound():
	get_node(idle_sounds[randi() % 4]).play()


const hit_sounds = ["aj1","aj2","aj3"]
func _play_hit_sound():
	get_node(hit_sounds[randi() % 3]).play()


func _get_tile_on_position(x,y):
	var tilemap = get_parent().get_node("TileMap")
	if not tilemap == null:
		var map_pos = tilemap.world_to_map(Vector2(x,y))
		var id = tilemap.get_cellv(map_pos)
		if id > -1:
			var tilename = tilemap.get_tileset().tile_get_name(id)
			return tilename
		else:
			return ""


func _check_collision_with_box():
	var x = position.x
	var y = position.y - 50
	if _get_tile_on_position(x,y) == "box":
		var tilemap = get_parent().get_node("TileMap")
		if not tilemap == null:
			var map_pos = tilemap.world_to_map(Vector2(x,y))
			tilemap.set_cellv(map_pos, -1)
			emit_signal("box_opened", Vector2(x,y), map_pos)
