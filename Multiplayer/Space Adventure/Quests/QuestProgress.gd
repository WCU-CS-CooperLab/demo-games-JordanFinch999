extends Node

@export var quest_id = "asteroid_1"

func increase_progress(amount = 1):
	Quests.increase_quest_progress(quest_id, amount)
