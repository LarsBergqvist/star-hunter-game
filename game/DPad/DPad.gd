extends TextureButton

export var visibleOnlyTouchscreen = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if visibleOnlyTouchscreen and not OS.has_touchscreen_ui_hint():
		$Sprite.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
