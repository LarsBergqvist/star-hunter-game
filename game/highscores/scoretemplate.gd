extends HBoxContainer


func _ready():
	pass
	
func set_Name(name):
	$Name.text = name.left(20)

func set_Score(score):
	$Score.text = score

