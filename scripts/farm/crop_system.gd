extends Node

# Crop lifecycle: EMPTY -> PLANTED -> GROWING -> READY -> HARVESTED

enum CropState { EMPTY, PLANTED, GROWING, READY }

var fields := {}

func create_field(field_id: String):
    fields[field_id] = {
        "crop": "",
        "state": CropState.EMPTY,
        "growth": 0.0
    }

func plant(field_id: String, crop_id: String) -> bool:
    if not fields.has(field_id):
        create_field(field_id)
    if fields[field_id]["state"] != CropState.EMPTY:
        return false
    fields[field_id]["crop"] = crop_id
    fields[field_id]["state"] = CropState.PLANTED
    fields[field_id]["growth"] = 0.0
    return true

func grow(field_id: String, amount: float):
    if not fields.has(field_id):
        return
    if fields[field_id]["state"] == CropState.EMPTY:
        return
    fields[field_id]["growth"] = clamp(fields[field_id]["growth"] + amount, 0.0, 1.0)
    if fields[field_id]["growth"] >= 1.0:
        fields[field_id]["state"] = CropState.READY
    else:
        fields[field_id]["state"] = CropState.GROWING

func harvest(field_id: String) -> String:
    if not fields.has(field_id):
        return ""
    if fields[field_id]["state"] != CropState.READY:
        return ""
    var crop_id = fields[field_id]["crop"]
    fields[field_id] = {
        "crop": "",
        "state": CropState.EMPTY,
        "growth": 0.0
    }
    return crop_id
