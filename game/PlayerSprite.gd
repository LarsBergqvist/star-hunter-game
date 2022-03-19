extends AnimatedSprite

func animate(cmd: Dictionary, playerState: PlayerState)->void:
	var characterId = playerState.characterId
	var length = playerState.velocity.length()
	if length > 1.0:
		play()
	else:
		play()
		animation = "stop" + str(characterId)
		
	if playerState.velocity.x != 0:
		if (playerState.is_jump_state):
			animation = "swim" + str(characterId)
		else:
			animation = "walk" + str(characterId)
		flip_v = false
		flip_h = playerState.velocity.x < 0
	elif (playerState.on_ladder):
		animation = "climb" + str(characterId)
	elif (playerState.is_jump_state):	
		animation = "jump" + str(characterId)
	elif (cmd.duck):
		animation = "duck" + str(characterId)
