class_name Commands

class CommandStates:
	func _init(wl, wr, cu, cd, j, d):
		walk_left = wl
		walk_right = wr
		climb_up = cu
		climb_down = cd
		jump = j
		duck = d

	var walk_left: bool = false
	var walk_right: bool = false
	var climb_up: bool = false
	var climb_down: bool = false
	var jump: bool = false
	var duck: bool = false


static func get_commands(playerState: PlayerState)->CommandStates:
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
	if !playerState.is_jump_state:
		climb_up = ui_up
	var down = ui_down
	var jump = Input.is_action_pressed("jump")
	
	var climb_down = false
	var duck = false
	if playerState.on_ladder:
		climb_down = down
	else:
		duck = down
	
	if abs(playerState.velocity.y) > 0 and playerState.on_ladder == false:
		climb_up = false
		climb_down = false

	return CommandStates.new(walk_left, walk_right, climb_up, climb_down, jump, duck)
	
static func is_active(cmd: CommandStates)->bool:
	return cmd.walk_left or cmd.walk_right or cmd.climb_up or cmd.climb_down or cmd.jump or cmd.duck
			