extends Area2D

class_name Gem

signal gem_taken

var gemType = GemType.Diamond

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if (rng.randf_range(0, 1) > 0.5):
		gemType = GemType.Heart
		$Sprite.texture = load("res://items/Heart.png")
	else:
		gemType = GemType.Diamond
		$Sprite.texture = load("res://items/gemRed.png")

func _on_RigidBody2D_body_entered( body ):
	if (not body.get("is_player") == null):
		emit_signal("gem_taken", gemType)
		queue_free()

