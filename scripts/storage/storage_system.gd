extends Node

var level := 1
var capacity := 100
var items := {}

func set_level(new_level: int, new_capacity: int) -> void:
    level = new_level
    capacity = new_capacity

func used_capacity() -> int:
    var total := 0
    for key in items:
        total += int(items[key])
    return total

func can_add(amount: int) -> bool:
    return used_capacity() + amount <= capacity

func add_item(product_id: String, amount: int) -> bool:
    if amount <= 0 or not can_add(amount):
        return false
    items[product_id] = int(items.get(product_id, 0)) + amount
    return true

func remove_item(product_id: String, amount: int) -> bool:
    if amount <= 0 or int(items.get(product_id, 0)) < amount:
        return false
    items[product_id] -= amount
    return true
