extends RigidBody2D

export (bool) var is_bullet = true


func _on_Bullet_body_entered(body):
	print("body entered")


func _on_Timer_timeout():
	queue_free()
	
func _setAnimation(characterId: int):
	$AnimatedSprite.animation = "ball" + str(characterId)
