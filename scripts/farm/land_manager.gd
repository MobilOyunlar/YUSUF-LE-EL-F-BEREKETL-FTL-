extends Node

# YUSUF İLE ELİF: BEREKETLİ ÇİFTLİĞİ
# Arazi genişletme yöneticisi.
# Normal kaynaklar veya elmas ile genişletme desteklenir.

var current_size: int = GameConfig.FARM_START_SIZE


func _ready() -> void:
	_load_current_size()


func _load_current_size() -> void:
	var saved_size = GameData.player.get("farm_size", GameConfig.FARM_START_SIZE)

	if typeof(saved_size) != TYPE_INT:
		current_size = GameConfig.FARM_START_SIZE
		return

	current_size = max(
		GameConfig.FARM_START_SIZE,
		int(saved_size)
	)


func get_current_size() -> int:
	return current_size


func get_next_expansion() -> Dictionary:
	for expansion in GameConfig.FARM_EXPANSIONS:
		if int(expansion["size"]) > current_size:
			return expansion.duplicate(true)

	return {}


func has_next_expansion() -> bool:
	return not get_next_expansion().is_empty()


func get_next_size() -> int:
	var expansion := get_next_expansion()

	if expansion.is_empty():
		return current_size

	return int(expansion["size"])


func get_next_diamond_cost() -> int:
	var expansion := get_next_expansion()

	if expansion.is_empty():
		return 0

	return int(expansion.get("diamonds", 0))


func get_next_resource_cost() -> Dictionary:
	var next_size := get_next_size()

	for cost in GameConfig.LAND_EXPANSION_RESOURCE_COSTS:
		if int(cost["size"]) == next_size:
			return cost.duplicate(true)

	return {}


func can_expand_with_resources() -> bool:
	var cost := get_next_resource_cost()

	if cost.is_empty():
		return false

	return (
		int(GameData.player.get("wood", 0)) >= int(cost.get("wood", 0))
		and int(GameData.player.get("stone", 0)) >= int(cost.get("stone", 0))
		and int(GameData.player.get("iron", 0)) >= int(cost.get("iron", 0))
	)


func expand_with_resources() -> Dictionary:
	var expansion := get_next_expansion()

	if expansion.is_empty():
		return {
			"success": false,
			"reason": "max_size"
		}

	var cost := get_next_resource_cost()

	if cost.is_empty():
		return {
			"success": false,
			"reason": "resource_cost_not_found"
		}

	if not can_expand_with_resources():
		return {
			"success": false,
			"reason": "not_enough_resources",
			"required": cost.duplicate(true),
			"current": {
				"wood": int(GameData.player.get("wood", 0)),
				"stone": int(GameData.player.get("stone", 0)),
				"iron": int(GameData.player.get("iron", 0))
			}
		}

	var old_size := current_size

	GameData.player["wood"] = int(GameData.player.get("wood", 0)) - int(cost.get("wood", 0))
	GameData.player["stone"] = int(GameData.player.get("stone", 0)) - int(cost.get("stone", 0))
	GameData.player["iron"] = int(GameData.player.get("iron", 0)) - int(cost.get("iron", 0))

	current_size = int(expansion["size"])
	_save_current_size()

	return {
		"success": true,
		"old_size": old_size,
		"new_size": current_size,
		"resources_spent": cost.duplicate(true)
	}


func expand_with_diamonds() -> Dictionary:
	var expansion := get_next_expansion()

	if expansion.is_empty():
		return {
			"success": false,
			"reason": "max_size"
		}

	var diamond_cost := int(expansion.get("diamonds", 0))

	if not EconomyManager.can_spend_diamonds(diamond_cost):
		return {
			"success": false,
			"reason": "not_enough_diamonds",
			"required_diamonds": diamond_cost,
			"current_diamonds": EconomyManager.get_diamonds()
		}

	if not EconomyManager.spend_diamonds(diamond_cost):
		return {
			"success": false,
			"reason": "payment_failed"
		}

	var old_size := current_size
	current_size = int(expansion["size"])
	_save_current_size()

	return {
		"success": true,
		"old_size": old_size,
		"new_size": current_size,
		"diamonds_spent": diamond_cost
	}


func _save_current_size() -> void:
	GameData.player["farm_size"] = current_size
