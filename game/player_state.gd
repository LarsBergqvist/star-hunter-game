class_name PlayerState

class Direction:
	enum { NONE, LEFT, RIGHT }

var velocity = Vector2()
var total_air_time = 100
var is_jumping = false
var characterId = 1
var is_hit = false
var on_ladder = false
var lastDirection = Direction.NONE
