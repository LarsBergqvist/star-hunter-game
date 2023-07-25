extends PanelContainer

var saving = false

func _ready():
	pass
func _process(_delta):
	if $VBox/Name.text.length() < 3:
		$VBox/Controls/Save.disabled = true
	else:
		$VBox/Controls/Save.disabled = false
	if saving:
		$VBox.visible = false


func _on_Save_pressed():
	saving = true
	var data_to_send = {
		"userName": $VBox/Name.text,
		"score": 678
	}
	
	var global = get_node("/root/global")	
	var query = JSON.print( data_to_send)
	var headers = ["Content-Type: application/json", "ApiKey: {apikey}".format({"apikey": global.apikey})]
	var use_ssl = true
	var url = "https://highscore-service-lb-api.azurewebsites.net/highscore-lists/{gameid}/game-results".format({"gameid": global.gameid})
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	var error = $HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	pass	
	

func _on_Cancel_pressed():
	get_tree().change_scene("res://main.tscn")
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		print("Failure!")
	get_tree().change_scene("res://main.tscn")
		
