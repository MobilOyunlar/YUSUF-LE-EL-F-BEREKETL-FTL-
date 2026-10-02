extends Node

const REWARD_PER_ACCOUNT := 10
const SAVE_PATH := "user://social_rewards.cfg"
const SAVE_SECTION := "social_rewards"

const SOCIAL_ACCOUNTS := [
	{
		"id": "x",
		"name": "X",
		"handle": "@LUMORIXSTUDIOS",
		"url": "https://x.com/LUMORIXSTUDIOS",
		"reward": REWARD_PER_ACCOUNT
	},
	{
		"id": "threads",
		"name": "Threads",
		"handle": "@lumorixstudios",
		"url": "https://www.threads.net/@lumorixstudios",
		"reward": REWARD_PER_ACCOUNT
	},
	{
		"id": "youtube",
		"name": "YouTube",
		"handle": "@lumorixstudios",
		"url": "https://www.youtube.com/@lumorixstudios",
		"reward": REWARD_PER_ACCOUNT
	},
	{
		"id": "instagram",
		"name": "Instagram",
		"handle": "@lumorixstudios",
		"url": "https://www.instagram.com/lumorixstudios/",
		"reward": REWARD_PER_ACCOUNT
	}
]

var claimed_rewards: Dictionary = {}


func _ready() -> void:
	_load_rewards()


func get_accounts() -> Array:
	return SOCIAL_ACCOUNTS.duplicate(true)


func has_claimed(account_id: String) -> bool:
	return bool(claimed_rewards.get(account_id, false))


func get_total_possible_reward() -> int:
	return SOCIAL_ACCOUNTS.size() * REWARD_PER_ACCOUNT


func mark_reward_claimed(account_id: String) -> bool:
	if account_id.is_empty() or has_claimed(account_id):
		return false

	for account in SOCIAL_ACCOUNTS:
		if str(account.get("id", "")) == account_id:
			claimed_rewards[account_id] = true
			_save_rewards()
			return true

	return false


func grant_verified_reward(account_id: String) -> bool:
	if account_id.is_empty() or has_claimed(account_id):
		return false

	for account in SOCIAL_ACCOUNTS:
		if str(account.get("id", "")) != account_id:
			continue

		var reward := int(account.get("reward", 0))
		if reward <= 0:
			return false

		if not EconomyManager.add_diamonds(reward):
			return false

		claimed_rewards[account_id] = true
		_save_rewards()
		return true

	return false


func get_claimed_reward_total() -> int:
	var total := 0

	for account in SOCIAL_ACCOUNTS:
		if has_claimed(str(account.get("id", ""))):
			total += int(account.get("reward", 0))

	return total


func _load_rewards() -> void:
	var config := ConfigFile.new()

	if config.load(SAVE_PATH) != OK:
		return

	for account in SOCIAL_ACCOUNTS:
		var account_id := str(account.get("id", ""))
		if account_id.is_empty():
			continue

		claimed_rewards[account_id] = bool(
			config.get_value(SAVE_SECTION, account_id, false)
		)


func _save_rewards() -> void:
	var config := ConfigFile.new()

	for account in SOCIAL_ACCOUNTS:
		var account_id := str(account.get("id", ""))
		if account_id.is_empty():
			continue

		config.set_value(
			SAVE_SECTION,
			account_id,
			has_claimed(account_id)
		)

	config.save(SAVE_PATH)
