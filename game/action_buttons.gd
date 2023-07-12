extends TextureButton

func _ready():
	var hasTouchScreen = OS.has_touchscreen_ui_hint()
	$TextureButton.visible = hasTouchScreen
	$TextureButton2.visible = hasTouchScreen
