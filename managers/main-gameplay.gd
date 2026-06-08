extends Node2D

# References to your component nodes from earlier
@onready var dialogue_box = $GhostTalk
@onready var customer_sprite = $Ghost

# The active character tracking
var current_customer: GhostProfile

func start_customer_interaction(character_id: String) -> void:
	# 1. Fetch the data container
	current_customer = CharacterDatabase.get_profile(character_id)
	if not current_customer:
		return
		
	# 2. Update visual and narrative UI elements dynamically
	customer_sprite.texture = load("res://visual-assets/character-sprites-mock/" + character_id + ".png")
	
	# 3. Hand off the custom dialogue data to your dialogue component
	dialogue_box.start_dialogue(current_customer.dialogue_data)

func check_brewed_drink(base: String, addon: String, topping: String) -> void:
	# Easy win-condition evaluation using the resource data!
	if base == current_customer.favorite_base and addon == current_customer.favorite_addon:
		dialogue_box.display_text("Wow! This is exactly what I wanted.")
	else:
		dialogue_box.display_text("Hmm... This doesn't taste quite right.")
