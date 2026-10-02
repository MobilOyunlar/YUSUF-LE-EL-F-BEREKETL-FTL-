extends Node

const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"

const MENU_MUSIC_PATH := "res://Assets/Audio/Music/Selected/menu_music.ogg"
const SFX_CLICK_PATH := "res://Assets/Audio/SFX/Selected/click.ogg"
const SFX_CONFIRMATION_PATH := "res://Assets/Audio/SFX/Selected/confirmation.ogg"
const SFX_ERROR_PATH := "res://Assets/Audio/SFX/Selected/error.ogg"
const SFX_HOVER_PATH := "res://Assets/Audio/SFX/Selected/hover.ogg"

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_index := 0

var menu_music: AudioStream
var sfx_click: AudioStream
var sfx_confirmation: AudioStream
var sfx_error: AudioStream
var sfx_hover: AudioStream


func _ready() -> void:
    _ensure_buses()
    _create_players()
    _load_audio()
    apply_settings()


func apply_settings() -> void:
    _set_bus_enabled(MUSIC_BUS, bool(GameData.settings.get("music_enabled", true)))
    _set_bus_enabled(SFX_BUS, bool(GameData.settings.get("effects_enabled", true)))


func set_music_enabled(enabled: bool) -> void:
    GameData.settings["music_enabled"] = enabled
    _set_bus_enabled(MUSIC_BUS, enabled)

    if enabled:
        play_menu_music()
    elif music_player:
        music_player.stop()


func set_effects_enabled(enabled: bool) -> void:
    GameData.settings["effects_enabled"] = enabled
    _set_bus_enabled(SFX_BUS, enabled)


func play_menu_music() -> void:
    if not bool(GameData.settings.get("music_enabled", true)):
        return

    if music_player == null or menu_music == null:
        return

    if music_player.playing:
        return

    music_player.stream = menu_music
    music_player.play()


func stop_music() -> void:
    if music_player:
        music_player.stop()


func play_click() -> void:
    _play_sfx(sfx_click)


func play_confirmation() -> void:
    _play_sfx(sfx_confirmation)


func play_error() -> void:
    _play_sfx(sfx_error)


func play_hover() -> void:
    _play_sfx(sfx_hover)


func _play_sfx(stream: AudioStream) -> void:
    if not bool(GameData.settings.get("effects_enabled", true)):
        return

    if stream == null or sfx_players.is_empty():
        return

    var player := sfx_players[sfx_index]
    sfx_index = (sfx_index + 1) % sfx_players.size()

    player.stream = stream
    player.play()


func _load_audio() -> void:
    menu_music = load(MENU_MUSIC_PATH) as AudioStream
    sfx_click = load(SFX_CLICK_PATH) as AudioStream
    sfx_confirmation = load(SFX_CONFIRMATION_PATH) as AudioStream
    sfx_error = load(SFX_ERROR_PATH) as AudioStream
    sfx_hover = load(SFX_HOVER_PATH) as AudioStream


func _create_players() -> void:
    if music_player == null:
        music_player = AudioStreamPlayer.new()
        music_player.name = "MusicPlayer"
        music_player.bus = MUSIC_BUS
        add_child(music_player)

    if not sfx_players.is_empty():
        return

    for i in range(4):
        var player := AudioStreamPlayer.new()
        player.name = "SFXPlayer" + str(i + 1)
        player.bus = SFX_BUS
        add_child(player)
        sfx_players.append(player)


func _ensure_buses() -> void:
    if AudioServer.get_bus_index(MUSIC_BUS) == -1:
        AudioServer.add_bus()
        AudioServer.set_bus_name(AudioServer.bus_count - 1, MUSIC_BUS)

    if AudioServer.get_bus_index(SFX_BUS) == -1:
        AudioServer.add_bus()
        AudioServer.set_bus_name(AudioServer.bus_count - 1, SFX_BUS)

    if AudioServer.get_bus_index("Master") == -1:
        return


func _set_bus_enabled(bus_name: String, enabled: bool) -> void:
    var index := AudioServer.get_bus_index(bus_name)
    if index == -1:
        return

    AudioServer.set_bus_mute(index, not enabled)
