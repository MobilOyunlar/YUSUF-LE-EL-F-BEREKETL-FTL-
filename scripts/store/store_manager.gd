extends Node

# Mağaza altyapısı.
# Google Play / App Store ürün kimlikleri daha sonra ayrı platform
# yapılandırmasından bağlanacaktır.

func get_diamond_packages() -> Array:
	return GameConfig.DIAMOND_PACKAGES.duplicate(true)

func get_coin_packages() -> Array:
	return GameConfig.COIN_PACKAGES.duplicate(true)

func calculate_unit_price(amount: int, price_try: float) -> float:
	if amount <= 0:
		return 0.0
	return price_try / float(amount)

func calculate_advantage_percent(base_amount: int, base_price: float, amount: int, price_try: float) -> float:
	if base_amount <= 0 or amount <= 0 or base_price <= 0.0:
		return 0.0

	var base_unit := calculate_unit_price(base_amount, base_price)
	var package_unit := calculate_unit_price(amount, price_try)

	if package_unit >= base_unit:
		return 0.0

	return (1.0 - package_unit / base_unit) * 100.0
