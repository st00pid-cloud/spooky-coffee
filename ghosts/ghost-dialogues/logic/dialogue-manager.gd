# DialogueManager.gd
extends Node

# Example function to trigger a ghost's narrative sequence when they walk in
func play_story_for_ghost(ghost: GhostProfile, current_visit: int) -> void:
	if ghost.dialogue_data.story_beats.has(current_visit):
		var lines: Array = ghost.dialogue_data.story_beats[current_visit]
		for line in lines:
			display_on_ui(ghost.character_name, line)

# Example function to trigger the Fog Toll transaction response
func play_fog_toll_cue(ghost: GhostProfile, star_rating: int) -> void:
	if star_rating >= 5:
		display_on_ui(ghost.character_name, ghost.dialogue_data.toll_high_satisfaction)
		# Trigger your visual effect: Anchor the shop, spawn memory token
	elif star_rating <= 2:
		display_on_ui(ghost.character_name, ghost.dialogue_data.toll_low_satisfaction)
		# Trigger your visual effect: Dim lights, dissolve walls

func display_on_ui(speaker: String, text: String) -> void:
	# Connect this to your actual UI textbox node
	print(speaker + ": " + text)
