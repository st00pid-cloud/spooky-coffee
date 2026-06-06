extends Node

# Signal emitted whenever the brew changes, allowing the HUD to update dynamically
signal recipe_updated(current_recipe: Dictionary)
signal perfect_match_triggered(achievement_id: String, vfx_type: String)

# 1. The Flavor Matrix & Database
const INGREDIENTS = {
	"bases": {
		"benguet_arabica": {"name": "Benguet Arabica", "tags": ["Bitter", "Strong", "Traditional"], "icon": "res://assets/ui/icons/arabica.png"},
		"sagada_roast": {"name": "Sagada Roast", "tags": ["Earthy", "Smooth", "Balanced"], "icon": "res://assets/ui/icons/sagada.png"},
		"matcha": {"name": "Matcha", "tags": ["Calming", "Herbaceous", "Modern"], "icon": "res://assets/ui/icons/matcha.png"}
	},
	"addons": {
		"strawberry_syrup": {"name": "La Trinidad Strawberry Syrup", "tags": ["Sweet", "Fruit", "Comfort"], "icon": "res://assets/ui/icons/strawberry.png"},
		"salabat": {"name": "Ginger Infusion (Salabat)", "tags": ["Spicy", "Heat", "Healing"], "icon": "res://assets/ui/icons/salabat.png"},
		"steamed_milk": {"name": "Steamed Milk", "tags": ["Creamy", "Comfort", "Neutral"], "icon": "res://assets/ui/icons/milk.png"}
	},
	"toppings": {
		"sea_salt_cream": {"name": "Sea Salt Cream", "tags": ["Salty", "Tears", "Regret"], "icon": "res://assets/ui/icons/sea_salt.png"},
		"muscovado": {"name": "Muscovado Sugar", "tags": ["Deep Sweet", "Local", "Raw"], "icon": "res://assets/ui/icons/muscovado.png"}
	}
}

# 2. Local Perfect Match Mapping (Hardcoded for immediate VFX/Steam Achievements)
const PERFECT_MATCHES = {
	"the_miner": {
		"required_ingredient": "salabat",
		"category": "addons",
		"achievement": "WARMTH_IN_THE_MINES",
		"vfx": "gold_sparks"
	},
	"the_weaver": {
		"required_ingredient": "benguet_arabica",
		"category": "bases",
		"achievement": "TRADITIONAL_THREADS",
		"vfx": "weaving_smoke"
	}
}

# 3. Current Brew State
var current_recipe = {
	"base": "",
	"addon": "",
	"topping": ""
}

# --- LOGIC METHODS ---

## Adds an ingredient to its proper slot, automatically replacing the previous one
func add_ingredient(category: String, ingredient_id: String) -> void:
	if not current_recipe.has(category):
		push_error("Invalid brewing category: " + category)
		return
		
	current_recipe[category] = ingredient_id
	recipe_updated.emit(current_recipe)
	_check_local_matches()

## Resets the current cup entirely
func reset_brew() -> void:
	current_recipe = {"base": "", "addon": "", "topping": ""}
	recipe_updated.emit(current_recipe)

## Converts the recipe dictionary into a rich, natural flavor string for the Gemini API
func generate_flavor_string() -> String:
	var base_id = current_recipe["base"]
	var addon_id = current_recipe["addon"]
	var topping_id = current_recipe["topping"]
	
	if base_id == "":
		return "An empty cup with nothing but wisps of Baguio fog."
		
	var base_data = INGREDIENTS["bases"][base_id]
	var base_tags = ", ".join(base_data["tags"]).to_lower()
	var description = "A %s %s drink" % [base_tags, base_data["name"]]
	
	if addon_id != "":
		var addon_data = INGREDIENTS["addons"][addon_id]
		var addon_tags = ", ".join(addon_data["tags"]).to_lower()
		description += ", infused with %s (%s)" % [addon_data["name"], addon_tags]
		
	if topping_id != "":
		var topping_data = INGREDIENTS["toppings"][topping_id]
		var topping_tags = ", ".join(topping_data["tags"]).to_lower()
		description += ", and finished with a layer of %s (%s)" % [topping_data["name"], topping_tags]
		
	return description + "."

## Internal check to immediately trigger client-side rewards
func _check_local_matches() -> void:
	# Assume the active customer ID is tracked globally (e.g., via a DialogueManager)
	var active_customer = _get_active_customer_id() 
	if not PERFECT_MATCHES.has(active_customer):
		return
		
	var match_data = PERFECT_MATCHES[active_customer]
	var target_slot = match_data["category"]
	
	# Mapping internal structural keys ("bases" -> "base")
	var recipe_key = target_slot.trim_suffix("s") 
	
	if current_recipe[recipe_key] == match_data["required_ingredient"]:
		perfect_match_triggered.emit(match_data["achievement"], match_data["vfx"])

func _get_active_customer_id() -> String:
	# Mock function: Replace this with your actual NPC tracking system
	return "the_miner"
