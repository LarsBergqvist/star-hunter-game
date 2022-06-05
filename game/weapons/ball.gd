extends RigidBody2D

export (bool) var is_bullet = true


func setAnimation(characterId: int):
	$AnimatedSprite.animation = "ball" + str(characterId)
    

func _on_Timer_timeout():
	queue_free()
