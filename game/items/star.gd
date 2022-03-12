extends Area2D

signal star_taken

func _ready():
	pass

func _on_Area2D_body_entered( body ):
	if (not body.get("is_player") == null):
		hide()
		emit_signal("star_taken")
		queue_free()
