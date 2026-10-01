extends Node

# V0.21 leaderboard service foundation.
# Production version should submit validated score events to the backend.
const PERIODS = ["weekly", "monthly", "yearly"]
const CATEGORIES = ["farm_value", "harvest", "production", "orders", "animal_care", "xp"]

func build_score_event(category: String, amount: int, source: String) -> Dictionary:
    return {"category": category, "amount": amount, "source": source}

func is_valid_category(category: String) -> bool:
    return category in CATEGORIES
