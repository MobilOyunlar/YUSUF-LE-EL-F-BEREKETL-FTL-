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
        var valid_values := ["low", "medium", "high", "ultra"]
        if not valid_values.has(value):
                value = "medium"

        GameData.settings["graphics_quality"] = value
        save_settings()
        apply_graphics_quality()

func set_sound_enabled(value: bool) -> void:
        GameData.settings["sound_enabled"] = value
        save_settings()

func set_music_enabled(value: bool) -> void:
        GameData.settings["music_enabled"] = value
        save_settings()

func set_effects_enabled(value: bool) -> void:
        GameData.settings["effects_enabled"] = value
        save_settings()

func apply_graphics_quality() -> void:
        var scene := get_tree().current_scene
        if scene == null:
                return

        var sun := scene.get_node_or_null("Sun") as DirectionalLight3D
        if sun == null:
                return

        var quality := str(GameData.settings.get("graphics_quality", "medium"))

        match quality:
                "low":
                        sun.shadow_enabled = false
                "medium":
                        sun.shadow_enabled = true
                        sun.shadow_bias = 0.05
                        sun.shadow_normal_bias = 1.0
                "high":
                        sun.shadow_enabled = true
                        sun.shadow_bias = 0.03
                        sun.shadow_normal_bias = 0.75
                "ultra":
                        sun.shadow_enabled = true
                        sun.shadow_bias = 0.015
                        sun.shadow_normal_bias = 0.5
                _:
                        sun.shadow_enabled = true
                        sun.shadow_bias = 0.05
                        sun.shadow_normal_bias = 1.0
