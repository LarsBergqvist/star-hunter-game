extends TextureButton

export var visibleOnlyTouchscreen = true

func _ready():
	if visibleOnlyTouchscreen and not OS.has_touchscreen_ui_hint():
		$TextureButton.visible = false
		$TextureButton2.visible = false
