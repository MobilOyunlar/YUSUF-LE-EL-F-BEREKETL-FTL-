extends Node

# 15 günlük kampanya altyapısı.
# Kampanyalar daha sonra sunucu/veri yapılandırması üzerinden yönetilebilir.

var active_promotion_id := ""
var active_promotion_percent := 0.0

func is_active() -> bool:
	return active_promotion_id != "" and active_promotion_percent > 0.0

func set_promotion(promotion_id: String, discount_percent: float) -> void:
	active_promotion_id = promotion_id
	active_promotion_percent = clamp(discount_percent, 0.0, 100.0)

func clear_promotion() -> void:
	active_promotion_id = ""
	active_promotion_percent = 0.0

func calculate_discounted_price(base_price: float) -> float:
	if not is_active():
		return base_price

	return snapped(
		base_price * (1.0 - active_promotion_percent / 100.0),
		0.01
	)
