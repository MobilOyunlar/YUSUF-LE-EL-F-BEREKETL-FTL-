extends Node

const SAVE_PATH := "user://bereketli_farm_v01.json"

func save_game(player: Node3D, crop_fields: Dictionary, coins: int, language: String) -> bool:
    var state := {
        "version": 1,
        "player": {"x": player.global_position.x, "y": player.global_position.y, "z": player.global_position.z},
        "coins": coins,
        "language": language,
        "crops": crop_fields.duplicate(true)
    }
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return false
    file.store_string(JSON.stringify(state))
    file.close()
    return true

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return {}
    var parsed = JSON.parse_string(file.get_as_text())
    file.close()
    if parsed is Dictionary:
        return parsed
    return {}
