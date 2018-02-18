extends Area2D

signal gem_taken

func _ready():
	pass

func _on_RigidBody2D_body_entered( body ):
	if (not body.get("is_player") == null):
		emit_signal("gem_taken")
		queue_free()

