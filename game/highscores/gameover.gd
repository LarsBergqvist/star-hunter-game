extends Control

func _ready():
	$PanelContainer.visible = false
	if global.last_score == 0 or global.apikey.length() == 0 or global.highscore_api.length() == 0:
		# No highscore api defined
		go_to_title_screen()
		return

	add_result_to_leaderboard(global.last_score)	
	
	$PanelContainer/VBox/HBox1/Score.text = str(global.last_score)
	$PanelContainer/VBox/Entername.connect("to_title_screen", self, "go_to_title_screen")
	

func add_result_to_leaderboard(score):
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	var headers = ["ApiKey: {apikey}".format({"apikey": global.apikey})]
	var url = "{endpoint}/highscore-lists/calculatedposition/{gameid}/{score}".format({"endpoint" : global.highscore_api, "gameid": global.gameid, "score": score})
	var res = $HTTPRequest.request(url, headers)
	if res != OK:
		go_to_title_screen()


func _on_request_completed(result, _response_code, _headers, body):
	if result != OK:
		go_to_title_screen()
		return

	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		go_to_title_screen()
		return

	if json.result.position != -1:
		# Did make it to the leaderboard
		$PanelContainer.visible = true
	else:
		# Did not make it to the leaderboard
		go_to_title_screen()
		
		
func go_to_title_screen():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	self.queue_free()
	get_tree().paused = false
	get_tree().change_scene("res://title_screen.tscn")
