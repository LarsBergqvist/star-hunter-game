extends AnimatedSprite

func animate_stop(characterId: int)->void:
	animation = "stop" + str(characterId)


func animate_talking(characterId: int)->void:
	animation = "talk" + str(characterId)


func is_animating_ducking(characterId: int)->bool:
	return animation == ("duck" + str(characterId))
	

func animate(cmd: Commands.CommandStates, playerState: PlayerState)->void:
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

func show_emote(name: String, time: float)->void:
	$EmoteTimer.wait_time = time
	$EmoteTimer.start()
	$emote.animation = name
	$emote.visible = true
		
func hide_emote()->void:
	$emote.visible = false

func on_EmoteTimer_timeout()->void:
	hide_emote()
	$EmoteTimer.stop()

func animate_hit_player(playerState: PlayerState)->void:
	show_emote("hit", 0.7)
	animation = "hit" + str(playerState.characterId)
	$trail.emitting = true

func stop_animating_hit()->void:
	$trail.emitting = false
