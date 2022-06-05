extends Area2D

signal player_hit
signal enemy_hit

var path: PathFollow2D = null
var _prevX = 0
var _pathIdx = 0
var _speed = 0
var _direction = 0
var _is_dead = false
const FALL_DEAD_SPEED = 4*50


func _ready():
	_pathIdx = randi() % 10000
	_speed = (randi() % 3 + 1)*50
	_direction = randi() % 2
	connect("body_entered", self, "_on_body_entered")


func _process(delta):
	if _is_dead:
		self.rotation += 0.1
		$AnimatedSprite.animation = "dead"
		position.y += FALL_DEAD_SPEED*delta
		if position.y > 1500:
			queue_free()
	else:
		if position.x > _prevX:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		_prevX = position.x
		
		if not path == null:
			path.set_offset(_pathIdx)
			position = path.position
			if _direction == 0:
				_pathIdx += _speed*delta	
			else:
				_pathIdx -= _speed*delta
	

func _on_body_entered( body ):
	if _is_dead:
		return
		
	if (not body.get("is_player") == null):
		if body.get_velocity().y > 200:
			_is_dead = true
			emit_signal("enemy_hit")
		else:
			emit_signal("player_hit")
	elif (not body.get("is_bullet") == null):
			_is_dead = true
			emit_signal("enemy_hit")
		

