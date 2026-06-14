extends Control

@onready var base_slot_label: Label = $Slots/BaseLabel
@onready var addon_slot_label: Label = $Slots/AddonLabel
@onready var topping_slot_label: Label = $Slots/ToppingLabel
@onready var clear_button: Button = $ClearButton

func _ready() -> void:
	# Connect to the global manager's signals
	IngredientManager.recipe_updated.connect(_update_hud)
	IngredientManager.perfect_match_triggered.connect(_on_perfect_match)
	clear_button.pressed.connect(IngredientManager.reset_brew)
	
	_update_hud(IngredientManager.current_recipe)

func _update_hud(recipe: Dictionary) -> void:
	base_slot_label.text = _get_display_text("bases", recipe["base"], "Empty Base Cup")
	addon_slot_label.text = _get_display_text("addons", recipe["addon"], "No Syrups/Infusions")
	topping_slot_label.text = _get_display_text("toppings", recipe["topping"], "No Toppings")

func _get_display_text(category: String, id: String, fallback: String) -> String:
	if id == "" or not IngredientManager.INGREDIENTS[category].has(id):
		return fallback
	return IngredientManager.INGREDIENTS[category][id]["name"]

func _on_perfect_match(achievement_id: String, vfx_type: String) -> void:
	print("LOCAL EFFECT: Play VFX -> ", vfx_type)
	print("STEAM INTEGRATION: Unlock achievement -> ", achievement_id)
	# Trigger your particle node or screen shake here!


func _on_clearbutton_pressed() -> void:
	pass # Replace with function body.
