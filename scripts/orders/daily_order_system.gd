extends Node

var targets := {}
var progress := {}

func load_targets(data: Dictionary) -> void:
    targets.clear()
    progress.clear()
    for target in data.get("daily_targets", []):
        targets[target.id] = target
        progress[target.id] = 0

func add_progress(target_id: String, amount: int = 1) -> bool:
    if not progress.has(target_id):
        return false
    progress[target_id] = min(int(progress[target_id]) + amount, int(targets[target_id].get("target", 0)))
    return progress[target_id] >= int(targets[target_id].get("target", 0))
