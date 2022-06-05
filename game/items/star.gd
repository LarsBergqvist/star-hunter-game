extends Area2D

signal star_taken


func _on_Area2D_body_entered(body: Node)->void:
	if (not body.get("is_player") == null):
		hide()
		emit_signal("star_taken")
		queue_free()
