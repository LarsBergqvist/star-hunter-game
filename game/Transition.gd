extends ColorRect

# Path to the next scene to transition to
export(String, FILE, "*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
onready var _anim_player := $AnimationPlayer

func _ready() -> void:
	show()
	# Plays the animation backward to fade in
	_anim_player.play_backwards("Fade")


func transition_to(_next_scene: String, previous: Node) -> void:
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	# Changes the scene
	get_tree().change_scene(_next_scene)
	previous.queue_free()
