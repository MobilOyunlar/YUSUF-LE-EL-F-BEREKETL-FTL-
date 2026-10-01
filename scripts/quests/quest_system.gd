extends Node

var quests := {}

func add_quest(quest_id: String, data: Dictionary):
    quests[quest_id] = data

func complete_quest(quest_id: String):
    if quests.has(quest_id):
        quests[quest_id]["completed"] = true
