extends KinematicBody2D

export (bool) var is_player = true
# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 1000.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const SCALE = 1
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600*SCALE
const WALK_MIN_SPEED = 10*SCALE
const WALK_MAX_SPEED = 200*SCALE
const STOP_FORCE = 1300*SCALE
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME = 0.2
const CLIMB_SPEED = 2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false
var on_ladder = false

var prev_jump_pressed = false


func _physics_process(delta):
	
	var tilemap = get_parent().get_node("TileMap")
	if not tilemap == null:
		var map_pos = tilemap.world_to_map(position)
		var id = tilemap.get_cellv(map_pos)
		if (id == 16):
			on_ladder = true
		else:
			on_ladder = false
	
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var climb_up = false
	if not jumping:
		climb_up = Input.is_action_pressed("ui_up")
	var climb_down = Input.is_action_pressed("ui_down")
	var jump = Input.is_action_pressed("jump")
	if jump:
		pass
	
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
	
	# Integrate forces to velocity
	#if (on_ladder == false):
	velocity += force * delta	
	# Integrate velocity into motion and move
	if climb_up:
		if (on_ladder):
			var pos = get_position()
			pos.y = pos.y - CLIMB_SPEED
			set_position(pos)
	elif climb_down and not is_on_floor():
		if (on_ladder):
			var pos = get_position()
			pos.y = pos.y + CLIMB_SPEED
			set_position(pos)
	elif (on_ladder and not jumping):
		var v = velocity
		v.y = 0
		velocity = move_and_slide(v, Vector2(0, 0))
	else:
		velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor() or on_ladder:
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
#	if (on_ladder == false):
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "stop"
#		$AnimatedSprite.stop()
		
	if velocity.x != 0:
    	$AnimatedSprite.animation = "right"
    	$AnimatedSprite.flip_v = false
    	$AnimatedSprite.flip_h = velocity.x < 0
	elif (on_ladder):
    	$AnimatedSprite.animation = "climb"
	elif (jumping):	
    	$AnimatedSprite.animation = "jump"
		
	on_air_time += delta
	prev_jump_pressed = jump
