extends Node
# CharacterDatabase.gd - Global or local manager

## A dictionary to hold loaded profiles mapped by a clean ID string
var profiles: Dictionary = {
	"baguio-colleges" : 1,
	"burnham" : 2,
	"hyatt" : 3, 
	"kafagway" : 4, 
	"kennon" : 5, 
	"laperal" : 6
}

func _ready() -> void:
	_load_characters()

func _load_characters() -> void:
	# You can manually drag and drop your 6 .tres files into an Array in the inspector,
	# or dynamically load them from your directory like this:
	var dir_path = "res://ghosts/ghost-profiles/"
	var dir = DirAccess.open(dir_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var full_path = dir_path + file_name
				var profile = load(full_path) as GhostProfile
				if profile:
					# Use lowercase name or a dedicated ID field as the dictionary key
					var key = profile.character_name.to_lower().replace(" ", "_")
					profiles[key] = profile
			file_name = dir.get_next()

## Helper function to easily retrieve a character anywhere in your code
func get_profile(character_id: String) -> GhostProfile:
	if profiles.has(character_id):
		return profiles[character_id]
	push_error("Character profile not found: " + character_id)
	return null
