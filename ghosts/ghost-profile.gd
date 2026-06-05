class_name GhostProfile
extends Resource

@export_group("Identity")
@export var character_name: String
@export_multiline var system_prompt_blueprint: String

@export_group("Gameplay Stats")
@export var favorite_base: String
@export var favorite_addon: String
@export var favorite_topping: String

@export_group("Narrative")
@export var dialogue_data: GhostDialogue
