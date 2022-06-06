extends Area2D

signal player_hit
signal enemy_hit

var path: PathFollow2D = null
var _prevX = 0
var _pathIdx = 0
var _speed = 0
var _direction = 0
var _is_dead = false
var _death_rotation = 0.1
const FALL_DEAD_SPEED = 4*50


func _ready():
	_pathIdx = randi() % 10000
	_speed = (randi() % 20 + 3) * 12
	var speed_scale_offset = 0
	if (_speed > 200):
		speed_scale_offset = 0.8
	elif (_speed > 150):
		speed_scale_offset = 0.5
	elif (_speed > 100):
		speed_scale_offset = 0.25
	elif (_speed > 50):
		speed_scale_offset = 0.10

	$AnimatedSprite.speed_scale += speed_scale_offset
	_direction = randi() % 2
	_death_rotation = (randf() - 0.5) * 0.3
	connect("body_entered", self, "_on_body_entered")


func _process(delta: float)->void:
	if _is_dead:
		_animate_death(delta)
	else:
		_animate_movement(delta)
	

func _animate_movement(delta: float)->void:
	$AnimatedSprite.flip_h = position.x > _prevX
	_prevX = position.x
	
	if not path == null:
		path.set_offset(_pathIdx)
		position = path.position
		if _direction == 0:
			_pathIdx += _speed*delta	
		else:
			_pathIdx -= _speed*delta


func _animate_death(delta: float)->void:
	self.rotation += _death_rotation
	$AnimatedSprite.animation = "dead"
	position.y += FALL_DEAD_SPEED * delta
	if position.y > 1500:
		queue_free()


func _on_body_entered(body: Node)->void:
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
		

