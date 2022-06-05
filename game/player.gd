extends KinematicBody2D
class_name Player

export (bool) var is_player = true

signal box_opened

const GRAVITY = 1000.0 # pixels/second/second

const WALK_FORCE = 600
const WALK_MIN_SPEED = 1
const WALK_MAX_SPEED = 300
const STOP_FORCE = 1300
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME = 0.2
const CLIMB_SPEED = 3
const BULLET_FORCE = 1000


var _playerState = PlayerState.new()


func get_velocity()->Vector2:
	return _playerState.velocity


func _ready()->void:
	_playerState.characterId = global.character
	$PlayerSprite.animate_stop(_playerState.characterId)
	var parent = get_parent()
	if parent != null:
		parent.connect("gem_was_taken", self, "on_gem_was_taken")
		parent.connect("star_was_taken", self, "on_star_was_taken")
		parent.connect("enemy_was_hit", self, "on_enemy_was_hit")
		parent.connect("player_was_hit", self, "on_player_was_hit")

		
func _physics_process(delta: float)->void:
	if _playerState.is_hit:
		_handle_hit_player()
		return
	else:
		$PlayerSprite.stop_animating_hit()
	
	_playerState.on_ladder = _get_tile_on_position(position.x, position.y+35) == "ladder"

	_check_collision_with_box()
			
	var cmd: Commands.CommandStates = Commands.get_commands(_playerState)
	
	_handle_idle_timer(cmd)
	
	_apply_movement(cmd, delta)

	if _playerState.velocity.x < 0:
		_playerState.lastDirection = PlayerState.Direction.LEFT
	elif _playerState.velocity.x > 0:
		_playerState.lastDirection = PlayerState.Direction.RIGHT

	_animate_sprite(cmd)

	_handle_shooting(cmd)


func _handle_shooting(cmd: Commands.CommandStates):
	if (cmd.shoot and global.ammo > 0):
		global.ammo = global.ammo - 1
		var bullet = preload("res://weapons/orb.tscn").instance()
		bullet.position = position
		bullet.setAnimation(_playerState.characterId)
		var bulletForce = BULLET_FORCE;
		if _playerState.lastDirection == PlayerState.Direction.LEFT:
			bulletForce = -bulletForce
		var force = Vector2(bulletForce, 0)
		bullet.applied_force = force
		get_parent().add_child(bullet)


func _handle_hit_player()->void:
	$PlayerSprite.animate_hit_player(_playerState)
	if $RecoverTimer.is_stopped():
		$RecoverTimer.start()


func _handle_idle_timer(cmd: Commands.CommandStates)->void:
	var active = Commands.is_active(cmd)
	if active or _playerState.on_ladder:
		$WaitAfterIdle.stop()
	elif $WaitAfterIdle.is_stopped():
		$WaitAfterIdle.start()
		
	
func _apply_movement(cmd: Commands.CommandStates, delta: float)->void:
	var vertical_force = Vector2(0, GRAVITY)
	var force = _add_horizontal_force(cmd.walk_left, cmd.walk_right, vertical_force, delta)
	_playerState.velocity += force * delta	
	
	if _playerState.on_ladder:
		_handle_ladder_movements(cmd.climb_up, cmd.climb_down)
	else:
		_playerState.velocity = move_and_slide(_playerState.velocity, Vector2(0, -1), false, 4,0.9,true)

	_handle_jumping(_playerState.on_ladder, cmd.jump, delta)
	
	
func _handle_jumping(on_ladder: bool, jump: bool, delta)->void:
	if is_on_floor() or on_ladder:
		_playerState.total_air_time = 0
	else:
		_playerState.total_air_time += delta
		
	if _playerState.is_jumping and _playerState.velocity.y >= 0:
		# If falling, no longer jumping
		_playerState.is_jumping = false
	
	if _playerState.total_air_time < JUMP_MAX_AIRBORNE_TIME and jump and !_playerState.is_jumping:
		# Jump must also be allowed to happen if the character left the floor a little while ago.
		# Makes controls more snappy.
		_playerState.velocity.y = -JUMP_SPEED
		_playerState.is_jumping = true

	
func _handle_ladder_movements(climb_up: bool, climb_down: bool)->void:
	if climb_up:
		var pos = get_position()
		pos.y = pos.y - CLIMB_SPEED
		set_position(pos)
	elif climb_down and not is_on_floor():
		var pos = get_position()
		pos.y = pos.y + CLIMB_SPEED
		set_position(pos)
	elif !_playerState.is_jumping:
		var v = _playerState.velocity
		v.y = 0
		_playerState.velocity = move_and_slide(v, Vector2(0, 0))
	else:
		_playerState.velocity = move_and_slide(_playerState.velocity, Vector2(0, -1))

	
func _add_horizontal_force(walk_left: bool, walk_right: bool, force: Vector2, delta: float)->Vector2:
	var stop = true
	var x = _playerState.velocity.x;
	
	if walk_left:
		if x <= WALK_MIN_SPEED and x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if x >= -WALK_MIN_SPEED and x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(x)
		var vlen = abs(x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		_playerState.velocity.x = vlen * vsign

	return force


func _animate_sprite(cmd: Commands.CommandStates)->void:
	$PlayerSprite.animate(cmd, _playerState)
	
	if ($PlayerSprite.is_animating_ducking(_playerState.characterId)):
		$CollisionPolygon2D.disabled = true
		$CollisionPolygon2DDuck.disabled = false
	else:
		$CollisionPolygon2D.disabled = false
		$CollisionPolygon2DDuck.disabled = true		


func _on_WaitAfterIdle_timeout()->void:
	$PlayerSprite.show_idle_emote()
	$WaitAfterIdle.stop()


func _on_RecoverTimer_timeout()->void:
	_playerState.is_hit = false
	$RecoverTimer.stop()


func on_gem_was_taken(gemType)->void:
	if gemType == GemType.DIAMOND:
		$PlayerSprite.show_emote("money", 0.5)
	elif gemType == GemType.HEART:
		$PlayerSprite.show_emote("heart", 0.5)
	elif gemType == GemType.ORB:
		$PlayerSprite.show_emote("happy", 0.5)


func on_star_was_taken()->void:
	$PlayerSprite.show_emote("star", 0.5)


func on_player_was_hit()->void:
	_playerState.is_hit = true


func on_enemy_was_hit()->void:
	$PlayerSprite.show_emote("haha", 0.5)


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
