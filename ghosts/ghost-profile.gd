# GhostProfile.gd
class_name GhostProfile
extends Resource

@export var character_name: String
@export_multiline var system_prompt_blueprint: String

# We store preferred ingredients to help guide potential local fallback logic 
# or to pass along to the AI as hints.
@export var favorite_base: String
@export var favorite_addon: String
@export var favorite_topping: String
