extends Control

onready var _transition_rect := $SceneTransitionRect

func _ready():
	$BackButton.connect("pressed", self, "_on_back_button_pressed")
	var global = get_node("/root/global")
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	var headers = ["ApiKey: {apikey}".format({"apikey": global.apikey})]
	$Status.text = "Loading..."
	$HTTPRequest.request("https://highscore-service-lb-api.azurewebsites.net/highscore-lists/{gameid}".format({"gameid": global.gameid}), headers)


func _on_back_button_pressed():
	_transition_rect.transition_to("res://title_screen.tscn", self)
	

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		$Status.text = "Failed loading highscores"
		return

	$Status.text = ""
		
	if json.result.results != null:
		for res in json.result.results:
			var instance = preload("scoretemplate.tscn").instance()
			instance.set_Name(res.userName)
			instance.set_Score(str(res.score))
			$Scroll/Leaderboard.add_child(instance)
			print(res.userName)
			print(str(res.score))
#	print(json.result.results)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
