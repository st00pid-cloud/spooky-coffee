extends Node

# Signal emitted whenever the brew changes, allowing the HUD to update dynamically
signal recipe_updated(current_recipe: Dictionary)
signal perfect_match_triggered(achievement_id: String, vfx_type: String)

# 1. The Flavor Matrix & Database
const INGREDIENTS = {
	"bases": {
		"benguet_arabica": {
			"name": "Benguet Arabica", 
			"tags": ["Earthy", "Dark", "Robust"], 
			"context": "Grown locally in Atok.",
			"icon": "res://assets/ui/icons/benguet_arabica.png"
		},
		"sagada_roast": {
			"name": "Sagada Roast", 
			"tags": ["Bittersweet", "Smoky", "Intense"], 
			"context": "High-altitude dark roast from Mt. Province.",
			"icon": "res://assets/ui/icons/sagada_roast.png"
		},
		"matcha_green_tea": {
			"name": "Matcha Green Tea", 
			"tags": ["Earthy", "Grassy", "Modern"], 
			"context": "Modern cafe favorite among students.",
			"icon": "res://assets/ui/icons/matcha.png"
		},
		"tapuy_essence": {
			"name": "Tapuy Essence", 
			"tags": ["Sweet", "Fermented rice note"], 
			"context": "Non-alcoholic reduction of native Ibaloi rice wine.",
			"icon": "res://assets/ui/icons/tapuy.png"
		}
	},
	"addons": {
		"ginger_infusion": {
			"name": "Ginger Infusion (Luya)", 
			"tags": ["Sharp", "Spicy", "Warming"], 
			"context": "Traditional salabat throat warmer for chilly nights.",
			"icon": "res://assets/ui/icons/ginger.png"
		},
		"strawberry_syrup": {
			"name": "Strawberry Syrup", 
			"tags": ["Heavy sweetness", "Fruity", "Tart"], 
			"context": "Baguio's signature fruit from the La Trinidad farms.",
			"icon": "res://assets/ui/icons/strawberry.png"
		},
		"sea_salt_cream": {
			"name": "Sea Salt Cream", 
			"tags": ["Savory", "Velvety", "Rich"], 
			"context": "Modern contrast element representing tears/grief.",
			"icon": "res://assets/ui/icons/sea_salt.png"
		},
		"condensed_milk": {
			"name": "Condensed Milk", 
			"tags": ["Creamy", "Intensely sugary"], 
			"context": "The historic, shelf-stable sweetener of post-war PH.",
			"icon": "res://assets/ui/icons/condensed_milk.png"
		}
	},
	"toppings": {
		"smoked_pine_needle_dust": {
			"name": "Smoked Pine Needle Dust", 
			"tags": ["Woody", "Aromatic", "Crisp"], 
			"context": "Sourced from the city's iconic Benguet pine trees.",
			"icon": "res://assets/ui/icons/pine_dust.png"
		},
		"crushed_ube_halaya": {
			"name": "Crushed Ube Halaya", 
			"tags": ["Thick", "Starchy", "Comforting"], 
			"context": "Purple yam jam, a staple Good Shepherd souvenir.",
			"icon": "res://assets/ui/icons/ube.png"
		},
		"gold_leaf_flakes": {
			"name": "Gold Leaf Flakes", 
			"tags": ["Metallic", "Luxury", "Flavorless"], 
			"context": "Visual nod to the mining history.",
			"icon": "res://assets/ui/icons/gold_flakes.png"
		},
		"edible_white_petals": {
			"name": "Edible White Petals", 
			"tags": ["Bitter", "Delicate", "Fleeting"], 
			"context": "Representation of mourning and funeral wreaths.",
			"icon": "res://assets/ui/icons/white_petals.png"
		}
	}
}
const PERFECT_MATCHES = {
	"baguio-colleges": {
		"required_ingredient": "matcha_green_tea",
		"category": "addons",
		"achievement": "",
		"vfx": ""
	},
	"burnham": {
		"required_ingredient": "tapuy_essence",
		"category": "bases",
		"achievement": "",
		"vfx": ""
	},
		"hyatt": {
		"required_ingredient": "benguet_arabica",
		"category": "bases",
		"achievement": "",
		"vfx": ""
	},
		"kafagway": {
		"required_ingredient": "benguet_arabica",
		"category": "bases",
		"achievement": "",
		"vfx": ""
	},
		"kennon": {
		"required_ingredient": "benguet_arabica",
		"category": "bases",
		"achievement": "",
		"vfx": ""
	},
		"laperal": {
		"required_ingredient": "benguet_arabica",
		"category": "bases",
		"achievement": "",
		"vfx": ""
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
