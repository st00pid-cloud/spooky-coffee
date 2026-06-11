# maingameplay file.txt
extends Node2D

@onready var ghost_sprite: Sprite2D = $Ghost
@onready var name_label: Label = $GhostTalk/NinePatchRect/PanelContainer/GhostNameLabel

func _ready() -> void:
	# Test loading a specific ghost on startup
	display_ghost("laperal")

## Fetches data from the database and updates the scene elements
func display_ghost(ghost_id: String) -> void:
	# Retrieve the profile from the Autoload database
	var profile: GhostProfile = CharacterDatabase.get_profile(ghost_id)
	
	if profile:
		# Update UI and Visuals
		name_label.text = profile.character_name
		ghost_sprite.texture = profile.character_sprite
		
		print("Successfully summoned: ", profile.character_name)
		print("Favorite topping: ", profile.favorite_topping)
	else:
		push_error("Failed to display ghost with ID: " + ghost_id)
