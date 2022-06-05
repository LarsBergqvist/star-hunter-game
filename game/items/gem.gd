extends Area2D
class_name Gem

signal gem_taken

var gemType = GemType.DIAMOND

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	var rand = rng.randf_range(0, 1)
	if rand > 0.8:
		gemType = GemType.HEART
		$Sprite.texture = load("res://items/Heart.png")
	elif rand > 0.6 and rand <= 0.8:
		gemType = GemType.DIAMOND
		$Sprite.texture = load("res://items/gemRed.png")
	else:
		gemType = GemType.BALL
		$Sprite.texture = load("res://weapons/ball" + str(global.character) + ".png")


func _on_RigidBody2D_body_entered( body ):
	if (not body.get("is_player") == null):
		emit_signal("gem_taken", gemType)
		queue_free()

