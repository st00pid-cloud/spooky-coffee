# GhostDialogue.gd
class_name GhostDialogue
extends Resource

# Key: Visit number (1 to 5)
# Value: Array of String dialogue lines for their main story progression
@export var story_beats: Dictionary = {
	1: [],
	2: [],
	3: [],
	4: [],
	5: []
}

@export_group("The Fog Toll Cues")
# Played when the player gives a 1-2 star drink during the shift
@export_multiline var toll_low_satisfaction: String
# Played when the player gives a 5-star drink (The Memory Payment)
@export_multiline var toll_high_satisfaction: String
