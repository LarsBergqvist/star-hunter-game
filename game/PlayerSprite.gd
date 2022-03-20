extends AnimatedSprite

func animate_stop(characterId: int)->void:
	animation = "stop" + str(characterId)


func is_animating_ducking(characterId: int)->bool:
	return animation == ("duck" + str(characterId))
	

func animate(cmd: Commands.CommandStates, playerState: PlayerState)->void:
	var characterId = playerState.characterId

	if ($PlayerSounds.player_makes_idle_sound() && !Commands.is_active(cmd)):
		animation = "talk" + str(characterId)
		play()
		return

	var length = playerState.velocity.length()
	if length > 1.0:
		play()
	else:
		play()
		animation = "stop" + str(characterId)
		
	if playerState.velocity.x != 0:
		if (playerState.is_jumping):
			animation = "swim" + str(characterId)
		else:
			animation = "walk" + str(characterId)
		flip_v = false
		flip_h = playerState.velocity.x < 0
	elif (playerState.on_ladder):
		animation = "climb" + str(characterId)
	elif (playerState.is_jumping):	
		animation = "jump" + str(characterId)
	elif (cmd.duck):
		animation = "duck" + str(characterId)

const idle_emotes = ["question", "question", "question", "happy"]
const idle_sounds = ["ooooh", "hmmm", "ehhh", "jippee"]
func show_idle_emote():
	var rnd = randi() % 4
	var sound = idle_sounds[rnd]
	var emote = idle_emotes[rnd]
	show_emote(emote, 2)
	$PlayerSounds.play_idle_sound(sound)

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
	if !$PlayerSounds.hit_sound_playing():
		$PlayerSounds.play_hit_sound()
	
	show_emote("hit", 0.7)
	animation = "hit" + str(playerState.characterId)
	$trail.emitting = true

func stop_animating_hit()->void:
	$trail.emitting = false
