extends Node

# Bereketli Çiftliği - Merkezi Ekonomi Yöneticisi
#
# Oyuncunun gerçek bakiye verisi GameData.player içinde tutulur.
# EconomyManager yalnızca bu veriyi güvenli şekilde yönetir.
#
# Premium para:
#   diamonds
#
# Normal oyun parası:
#   coins

func get_diamonds() -> int:
	return int(GameData.player.get("diamonds", 0))


func get_coins() -> int:
	return int(GameData.player.get("coins", 0))


func add_diamonds(amount: int) -> bool:
	if amount <= 0:
		return false

	GameData.player["diamonds"] = get_diamonds() + amount
	return true


func add_coins(amount: int) -> bool:
	if amount <= 0:
		return false

	GameData.player["coins"] = get_coins() + amount
	return true


func can_spend_diamonds(amount: int) -> bool:
	return amount >= 0 and get_diamonds() >= amount


func can_spend_coins(amount: int) -> bool:
	return amount >= 0 and get_coins() >= amount


func spend_diamonds(amount: int) -> bool:
	if not can_spend_diamonds(amount):
		return false

	GameData.player["diamonds"] = get_diamonds() - amount
	return true


func spend_coins(amount: int) -> bool:
	if not can_spend_coins(amount):
		return false

	GameData.player["coins"] = get_coins() - amount
	return true


func get_balance() -> Dictionary:
	return {
		"diamonds": get_diamonds(),
		"coins": get_coins()
	}
