extends RigidBody2D

var is_bullet = true


func setAnimation(characterId: int):
	$AnimatedSprite.animation = "ball" + str(characterId)
	

func _on_Timer_timeout():
	$AnimationPlayer.play("shrink")


func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "shrink"):
		queue_free()
