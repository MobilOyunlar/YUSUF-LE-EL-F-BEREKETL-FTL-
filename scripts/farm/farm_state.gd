extends Node

# Permanent infrastructure: cannot be moved.
var fixed_objects := {
    "water_pump": true,
    "mill": true
}

# Everything else can be placed/moved by the player.
var movable_objects := {}

func place_object(object_id: String, position: Vector2, rotation_degrees := 0.0):
    movable_objects[object_id] = {
        "position": position,
        "rotation": rotation_degrees
    }

func move_object(object_id: String, position: Vector2, rotation_degrees := 0.0):
    if fixed_objects.has(object_id):
        return false
    place_object(object_id, position, rotation_degrees)
    return true
