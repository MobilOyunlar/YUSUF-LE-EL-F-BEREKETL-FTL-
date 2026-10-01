extends Node

var expansion_levels = [
    Vector2(12, 12),
    Vector2(14, 14),
    Vector2(16, 16),
    Vector2(18, 18)
]
var current_level := 0

func get_current_size() -> Vector2:
    return expansion_levels[current_level]

func expand() -> bool:
    if current_level + 1 >= expansion_levels.size():
        return false
    current_level += 1
    return true
