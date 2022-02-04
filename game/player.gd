extends KinematicBody2D

export (bool) var is_player = true
export (bool) var was_hit = false

signal box_opened

const GRAVITY = 1000.0 # pixels/second/second

const WALK_FORCE = 600
const WALK_MIN_SPEED = 1 # 10
const WALK_MAX_SPEED = 300 # 200
const STOP_FORCE = 1300
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME = 0.2
const CLIMB_SPEED = 3 # 2


var characterId = 1

var velocity = Vector2()
var _total_air_time = 100
var _is_jump_state = false

	
func _ready():
	var global = get_node("/root/global")
	characterId = global.character
	$AnimatedSprite.animation = "stop" + str(characterId)
		
func _physics_process(delta):
	if was_hit:
		_handle_hit_player()
		return
	else:
		$AnimatedSprite/trail.emitting = false
	
	var on_ladder = _get_tile_on_position(position.x, position.y+35) == "ladder"
	_check_collision_with_box()
			
	var cmd = _get_movement_commands(on_ladder)

	_handle_idle_timer(cmd, on_ladder)
	
	_apply_movement(cmd, on_ladder, delta)	
		
	_animate_sprite(cmd, on_ladder)


func _handle_hit_player():
	$AnimatedSprite.animation = "hit" + str(characterId)
	$AnimatedSprite/trail.emitting = true
	if $RecoverTimer.is_stopped():
		$RecoverTimer.start()
		_play_hit_sound()

	
func _is_active(cmd):
	return cmd.walk_left or cmd.walk_right or cmd.climb_up or cmd.climb_down or cmd.jump or cmd.duck


func _player_makes_sound():
	return $ooooh.playing or $jippee.playing or $hmmm.playing or $ehhh.playing


func _handle_idle_timer(cmd, on_ladder):
	var active = _is_active(cmd)
	if active or on_ladder:
		$WaitAfterIdle.stop()
	else:
		if $WaitAfterIdle.is_stopped():
			$WaitAfterIdle.start()
	
	
func _get_movement_commands(on_ladder):
	var ui_left = false
	var ui_right = false
	var ui_up = false
	var ui_down = false
	if Input.is_action_pressed("ui_left"):
		ui_left = true
	elif Input.is_action_pressed("ui_right"):
		ui_right = true
	elif Input.is_action_pressed("ui_up"):
		ui_up = true
	elif Input.is_action_pressed("ui_down"):
		ui_down = true
		
	var walk_left = ui_left
	var walk_right = ui_right
	var climb_up = false
	if !_is_jump_state:
		climb_up = ui_up
	var down = ui_down
	var jump = Input.is_action_pressed("jump")
	
	var climb_down = false
	var duck = false
	if on_ladder:
		climb_down = down
	else:
		duck = down
	
	if abs(velocity.y) > 0 and on_ladder == false:
		climb_up = false
		climb_down = false

	return {"walk_left": walk_left,
			"walk_right":walk_right,
			"climb_up": climb_up,
			"climb_down": climb_down,
			"jump": jump,
			"duck": duck}
	
	
func _apply_movement(cmd, on_ladder, delta):
	var force = Vector2(0, GRAVITY)
	force = _get_horizontal_force(cmd.walk_left, cmd.walk_right, force, delta)
	velocity += force * delta	
	
	if on_ladder:
		_handle_ladder_movements(cmd.climb_up, cmd.climb_down)
	else:
		velocity = move_and_slide(velocity, Vector2(0, -1), false, 4,0.9,true)

	_handle_jumping(on_ladder, cmd.jump, delta)
	
	
func _handle_jumping(on_ladder, jump, delta):
	if is_on_floor() or on_ladder:
		_total_air_time = 0
	else:
		_total_air_time += delta
		
	if _is_jump_state and velocity.y >= 0:
		# If falling, no longer jumping
		_is_jump_state = false
	
	if _total_air_time < JUMP_MAX_AIRBORNE_TIME and jump and !_is_jump_state:
		# Jump must also be allowed to happen if the character left the floor a little while ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		_is_jump_state = true

	
func _handle_ladder_movements(climb_up, climb_down):
		if climb_up:
			var pos = get_position()
			pos.y = pos.y - CLIMB_SPEED
			set_position(pos)
		elif climb_down and not is_on_floor():
			var pos = get_position()
			pos.y = pos.y + CLIMB_SPEED
			set_position(pos)
		elif !_is_jump_state:
			var v = velocity
			v.y = 0
			velocity = move_and_slide(v, Vector2(0, 0))
		else:
			velocity = move_and_slide(velocity, Vector2(0, -1))

	
func _get_horizontal_force(walk_left, walk_right, force, delta):
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign

	return force


func _animate_sprite(cmd, on_ladder):
	var length = velocity.length()
	if length > 1.0:
		print(length)
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "stop" + str(characterId)
		
	if velocity.x != 0:
		if (_is_jump_state):
			$AnimatedSprite.animation = "swim" + str(characterId)
		else:
			$AnimatedSprite.animation = "walk" + str(characterId)
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif (on_ladder):
		$AnimatedSprite.animation = "climb" + str(characterId)
	elif (_is_jump_state):	
		$AnimatedSprite.animation = "jump" + str(characterId)
	elif (cmd.duck):
		$AnimatedSprite.animation = "duck" + str(characterId)
	
	if !_is_active(cmd) and _player_makes_sound():
		$AnimatedSprite.animation = "talk" + str(characterId)

	if ($AnimatedSprite.animation == ("duck" + str(characterId))):
		$CollisionPolygon2D.disabled = true
		$CollisionPolygon2DDuck.disabled = false
	else:
		$CollisionPolygon2D.disabled = false
		$CollisionPolygon2DDuck.disabled = true		

	
func _on_WaitAfterIdle_timeout():
	$WaitAfterIdle.stop()
	_play_idle_sound()


func _on_RecoverTimer_timeout():
	was_hit = false
	$RecoverTimer.stop()


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
