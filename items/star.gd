extends Area2D

signal star_taken

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered( body ):
	if (not body.get("is_player") == null):
		$CollisionPolygon2D.disabled = true
		hide()
		emit_signal("star_taken")
		queue_free()
