extends Node

# V0.4 placement rules.
# Fixed: water_pump, mill.
# Movable: all other registered objects.

var objects := {
    "water_pump": {"fixed": true, "position": Vector2(1040, 470), "rotation": 0.0},
    "mill": {"fixed": true, "position": Vector2(840, 300), "rotation": 0.0}
}

func register_object(object_id: String, position: Vector2, fixed := false):
    objects[object_id] = {
        "fixed": fixed,
        "position": position,
        "rotation": 0.0
    }

func move_object(object_id: String, new_position: Vector2) -> bool:
    if not objects.has(object_id):
        return false
    if objects[object_id]["fixed"]:
        return false
    objects[object_id]["position"] = new_position
    return true

func rotate_object(object_id: String, degrees: float) -> bool:
    if not objects.has(object_id):
        return false
    if objects[object_id]["fixed"]:
        return false
    objects[object_id]["rotation"] += degrees
    return true

func get_object(object_id: String):
    return objects.get(object_id, null)
