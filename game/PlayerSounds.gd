extends Node


const idle_sounds = ["ooooh","jippee","hmmm","ehhh"]
const hit_sounds = ["aj1","aj2","aj3"]


func play_idle_sound()->void:
	get_node(idle_sounds[randi() % 4]).play()


func play_hit_sound()->void:
	get_node(hit_sounds[randi() % 3]).play()


func player_makes_idle_sound()->bool:
	return $ooooh.playing or $jippee.playing or $hmmm.playing or $ehhh.playing
