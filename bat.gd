extends Area2D

signal player_hit

var path = null
var prevX = 0
var pathIdx = 0
var speed = 0
var direction = 0

func _ready():
	pathIdx = randi() % 10000
	speed = randi() % 3 + 1
	direction = randi() % 2

func _process(delta):
	if position.x > prevX:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	prevX = position.x
	
	if not path == null:
		path.set_offset(pathIdx)
		position = path.position
		if direction == 0:
			pathIdx += speed
		else:
			pathIdx -= speed


#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

	

func _on_Bat_body_entered( body ):
	if (not body.get("is_player") == null):
		emit_signal("player_hit")
