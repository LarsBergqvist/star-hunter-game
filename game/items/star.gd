extends Area2D

signal star_taken


func _on_Area2D_body_entered(body: Node)->void:
	if (body is Player):
		hide()
		emit_signal("star_taken")
		queue_free()
