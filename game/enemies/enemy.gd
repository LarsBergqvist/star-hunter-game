extends Area2D

signal player_hit
signal enemy_hit

var path = null
var prevX = 0
var pathIdx = 0
var speed = 0
var direction = 0
var is_dead = false
const fall_dead_speed = 4*50

func _ready():
	pathIdx = randi() % 10000
	speed = (randi() % 3 + 1)*50
	direction = randi() % 2
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if is_dead:
		$AnimatedSprite.animation = "dead"
		position.y += fall_dead_speed*delta
		if position.y > 1500:
			queue_free()
	else:
		if position.x > prevX:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		prevX = position.x
		
		if not path == null:
			path.set_offset(pathIdx)
			position = path.position
			if direction == 0:
				pathIdx += speed*delta	
			else:
				pathIdx -= speed*delta
	

func _on_body_entered( body ):
	if is_dead:
		return
		
	if (not body.get("is_player") == null):
		if (body.velocity.y > 200):
			print(body.velocity.y)
			is_dead = true
			emit_signal("enemy_hit")
		else:
			emit_signal("player_hit")

