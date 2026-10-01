extends Node

var slots := 6
var refresh_minutes := 15
var active_orders := []

func load_templates(data: Dictionary) -> void:
    active_orders = data.get("orders", []).duplicate(true)
    if active_orders.size() > slots:
        active_orders.resize(slots)

func complete_order(index: int) -> Dictionary:
    if index < 0 or index >= active_orders.size():
        return {}
    var order = active_orders[index]
    active_orders.remove(index)
    return order

func discard_order(index: int) -> void:
    if index >= 0 and index < active_orders.size():
        active_orders.remove(index)
