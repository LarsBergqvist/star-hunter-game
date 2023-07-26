extends PanelContainer

signal to_title_screen

var saving = false

func _ready():
	$VBox/Name.text = global.last_name
	
	
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
		"score": global.last_score
	}
	
	global.last_name = $VBox/Name.text
	var query = JSON.print( data_to_send)
	var headers = ["Content-Type: application/json", "ApiKey: {apikey}".format({"apikey": global.apikey})]
	var use_ssl = true
	var url = "{endpoint}/highscore-lists/{gameid}/game-results".format({"endpoint" : global.highscore_api, "gameid": global.gameid})
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	$Status.text = "Saving..."


func _on_Cancel_pressed():
	emit_signal("to_title_screen")


func _on_request_completed(result, _response_code, _headers, body):
	if result != OK:
		saving_failed()
		return

	var json = JSON.parse(body.get_string_from_utf8())
	if json.error != OK:
		saving_failed()
		return

	$Status.text = ""
	
	emit_signal("to_title_screen")

func saving_failed():
	$Status.text = "Saving failed..."
	yield(get_tree().create_timer(3.0),"timeout")
	$Status.text = ""
	emit_signal("to_title_screen")
