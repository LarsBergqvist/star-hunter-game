extends Control

onready var _transition_rect := $SceneTransitionRect

func _ready():
	$BackButton.connect("pressed", self, "_on_back_button_pressed")
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	var headers = ["ApiKey: {apikey}".format({"apikey": global.apikey})]
	$Status.text = "Loading..."
	$HTTPRequest.request("{endpoint}/highscore-lists/{gameid}".format({"endpoint" : global.highscore_api, "gameid": global.gameid}), headers)


func _on_back_button_pressed():
	_transition_rect.transition_to("res://title_screen.tscn", self)
	

func _on_request_completed(result, _response_code, _headers, body):
	if result != OK:
		loading_failed()
		return

	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		loading_failed()
		return

	$Status.text = ""
		
	if json.result.results != null:
		for res in json.result.results:
			var instance = preload("scoretemplate.tscn").instance()
			instance.set_Name(res.userName)
			instance.set_Score(str(res.score))
			$Scroll/Leaderboard.add_child(instance)


func loading_failed():
	$Status.text = "Failed loading highscores"
