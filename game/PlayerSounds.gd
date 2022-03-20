extends Node

const hit_sounds = ["aj1","aj2","aj3"]

func play_idle_sound(idle_sound: String)->void:
	get_node(idle_sound).play()


func play_hit_sound()->void:
	get_node(hit_sounds[randi() % 3]).play()


func hit_sound_playing()->bool:
	return $aj1.playing or $aj2.playing or $aj3.playing


func player_makes_idle_sound()->bool:
	return $ooooh.playing or $jippee.playing or $hmmm.playing or $ehhh.playing
