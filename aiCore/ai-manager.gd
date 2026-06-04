# AIManager.gd
extends HTTPRequest

signal response_received(rating: int, dialogue: String)
signal request_failed(error_message: String)

# Replace with your actual Gemini API key (Keep it safe/don't commit to public Git!)
const API_KEY: String = "YOUR_GEMINI_API_KEY_HERE"
const GEMINI_URL: String = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key="

func send_drink_to_ghost(ghost: GhostProfile, drink: Dictionary) -> void:
	var url = GEMINI_URL + API_KEY
	
	# Structure the user prompt injection
	var user_prompt = """
	[DRINK SERVED]
	Base: %s
	Addon: %s
	Topping: %s
	
	Evaluate the drink based on your profile, determine your numerical rating (1-5), and respond strictly using the required JSON format.
	""" % [drink.get("base", ""), drink.get("addon", ""), drink.get("topping", "")]

	# Combine the system instructions and the user prompt into the payload
	# Gemini Flash expects system instructions in a separate field for strict adherence
	var payload = {
		"contents": [
			{
				"parts": [
					{"text": user_prompt}
				]
			}
		],
		"systemInstruction": {
			"parts": [
				{"text": ghost.system_prompt_blueprint}
			]
		},
		"generationConfig": {
			"responseMimeType": "application/json" # Enforces JSON output at the model level
		}
	}
	
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify(payload)
	
	# Send the async request
	var error = request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		request_failed.emit("Failed to initiate HTTP request.")

# Godot 4 callback when the network request finishes
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		request_failed.emit("Server returned code: " + str(response_code))
		return
		
	var response_text = body.get_string_from_utf8()
	var json = JSON.new()
	var parse_err = json.parse(response_text)
	
	if parse_err != OK:
		request_failed.emit("Failed to parse Gemini API response wrapper.")
		return
		
	var raw_data = json.get_data()
	
	# Safely dig through the Gemini response JSON structure to get our inner text
	if not raw_data.has("candidates") or raw_data["candidates"].is_empty():
		request_failed.emit("No text candidates returned from AI.")
		return
		
	var inner_json_string = raw_data["candidates"][0]["content"]["parts"][0]["text"]
	
	# Enforce clean formatting fallback just in case markdown backticks slipped in
	inner_json_string = _clean_markdown(inner_json_string)
	
	# Now parse the actual gameplay JSON payload returned by the ghost
	var ghost_json = JSON.new()
	var ghost_parse_err = ghost_json.parse(inner_json_string)
	
	if ghost_parse_err == OK:
		var game_data = ghost_json.get_data()
		var rating = game_data.get("rating", 3)
		var dialogue = game_data.get("dialogue", "...")
		response_received.emit(int(rating), str(dialogue))
	else:
		request_failed.emit("Ghost failed to output valid game-ready JSON format.")

# Helper function to scrape off markdown blocks if the LLM ignores instructions
func _clean_markdown(text: String) -> String:
	var cleaned = text.strip_edges()
	if cleaned.begins_with("```json"):
		cleaned = cleaned.get_slice("
```json", 1).get_slice("```", 0).strip_edges()
	elif cleaned.begins_with("```"):
		cleaned = cleaned.get_slice("
```", 1).get_slice("```", 0).strip_edges()
	return cleaned
