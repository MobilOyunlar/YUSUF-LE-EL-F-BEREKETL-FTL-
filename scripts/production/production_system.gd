extends Node

# Data-driven production foundation.
# Recipes will be loaded from JSON so new machines/products do not require rewriting core code.

var recipes := {}

func register_recipe(recipe_id: String, input_data: Dictionary, output_data: Dictionary, duration_seconds: int):
    recipes[recipe_id] = {
        "inputs": input_data,
        "outputs": output_data,
        "duration": duration_seconds
    }

func get_recipe(recipe_id: String):
    return recipes.get(recipe_id, null)
