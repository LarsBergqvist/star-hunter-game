extends TextureButton

func _ready():
	var hasTouchScreen = OS.has_touchscreen_ui_hint()
	$TextureButton/JumpButton/Label.visible = hasTouchScreen
	$TextureButton2/ShootButton/Label.visible = hasTouchScreen
