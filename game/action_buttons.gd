extends TextureButton

func _ready():
	var hasTouchScreen = true #OS.has_touchscreen_ui_hint()
	$TextureButton.visible = hasTouchScreen
	$TextureButton2.visible = hasTouchScreen
