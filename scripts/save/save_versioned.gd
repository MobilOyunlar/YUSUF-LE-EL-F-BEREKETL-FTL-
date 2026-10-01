extends Node

const SAVE_VERSION := 7
const SAVE_PATH := "user://farm_save.json"

func build_save(data: Dictionary) -> Dictionary:
    return {"save_version": SAVE_VERSION, "data": data}
