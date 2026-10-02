extends Node

const SETTINGS_PATH := "user://settings.cfg"

func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return

	GameData.language = str(config.get_value("general", "language", GameData.language))
	GameData.settings["language"] = GameData.language
	GameData.settings["graphics_quality"] = str(config.get_value("graphics", "quality", GameData.settings["graphics_quality"]))
	GameData.settings["sound_enabled"] = bool(config.get_value("audio", "sound_enabled", GameData.settings["sound_enabled"]))
	GameData.settings["music_enabled"] = bool(config.get_value("audio", "music_enabled", GameData.settings["music_enabled"]))
	GameData.settings["effects_enabled"] = bool(config.get_value("audio", "effects_enabled", GameData.settings["effects_enabled"]))

func save_settings() -> void:
	var config := ConfigFile.new()

	config.set_value("general", "language", GameData.language)
	config.set_value("graphics", "quality", GameData.settings["graphics_quality"])
	config.set_value("audio", "sound_enabled", GameData.settings["sound_enabled"])
	config.set_value("audio", "music_enabled", GameData.settings["music_enabled"])
	config.set_value("audio", "effects_enabled", GameData.settings["effects_enabled"])

	config.save(SETTINGS_PATH)

func set_language(value: String) -> void:
	GameData.language = value
	GameData.settings["language"] = value
	save_settings()

func set_graphics_quality(value: String) -> void:
	GameData.settings["graphics_quality"] = value
	save_settings()

func set_sound_enabled(value: bool) -> void:
	GameData.settings["sound_enabled"] = value
	save_settings()

func set_music_enabled(value: bool) -> void:
	GameData.settings["music_enabled"] = value
	save_settings()

func set_effects_enabled(value: bool) -> void:
	GameData.settings["effects_enabled"] = value
	save_settings()
