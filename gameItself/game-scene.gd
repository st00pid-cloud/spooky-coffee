# GameScene.gd
extends Node2D

@onready var ai_manager: HTTPRequest = $AIManager

# Preload your custom resources here
var baguio_colleges_resource = preload("res://ghosts/ghost-profiles/baguio-colleges.tres")
var burnham_resource = preload("res://ghosts/ghost-profiles/burnham.tres")
var hyatt_resource = preload("res://ghosts/ghost-profiles/hyatt.tres")
var kafagway_resource = preload("res://ghosts/ghost-profiles/kafagway.tres")
var kennon_resource = preload("res://ghosts/ghost-profiles/kennon.tres")
var laperal_resource = preload("res://ghosts/ghost-profiles/laperal.tres")

var current_ghost: GhostProfile

func _ready() -> void:
	# Connect the AI manager signals
	ai_manager.response_received.connect(_on_ghost_responded)
	ai_manager.request_failed.connect(_on_ai_error)
	
	# Start the shift by bringing in a character
	spawn_ghost(baguio_colleges_resource)

func spawn_ghost(ghost: GhostProfile) -> void:
	current_ghost = ghost
	print("A fog rolls in... " + ghost.character_name + " approaches the counter.")
	# Update your UI elements here (e.g., set character sprite, clear text box)

func _on_player_serves_drink() -> void:
	# Fetch choices from your UI recipe assembly station
	var served_drink = {
		"base": "Benguet Arabica",
		"addon": "Ginger Infusion",
		"topping": "Gold Leaf Flakes"
	}
	
	print("Serving drink to " + current_ghost.character_name + "...")
	ai_manager.send_drink_to_ghost(current_ghost, served_drink)

func _on_ghost_responded(rating: int, dialogue: String) -> void:
	print("--- GHOST RESPONSE ---")
	print("Rating: ", rating, "/5")
	print("Dialogue: ", dialogue)
	# UPDATE GAME STATE: 
	# 1. Update UI dialogue box with 'dialogue' text string.
	# 2. Add 'rating' value to your game jam overall score counter.

func _on_ai_error(msg: String) -> void:
	print("AI Error: ", msg)
	# Fallback system to keep game jam judges from getting a broken screen
	_on_ghost_responded(3, "*The spirit stares into the fog, unable to find the words.*")
