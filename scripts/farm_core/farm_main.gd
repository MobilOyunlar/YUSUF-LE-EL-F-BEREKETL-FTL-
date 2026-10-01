extends Node2D

# V0.4 Farm Core
# Lightweight foundation for the first playable farm loop.

var camera_position := Vector2(640, 360)
var camera_zoom := 1.0
var farm_level := 1

func _ready():
    $UI/Status.text = "Çiftlik çekirdeği aktif | Seviye %d | Para %d | Elmas %d" % [
        GameData.player.level,
        GameData.player.coins,
        GameData.player.diamonds
    ]
    print("Farm Core V0.4 loaded.")

func pan_camera(delta: Vector2):
    camera_position += delta

func zoom_camera(factor: float):
    camera_zoom = clamp(camera_zoom * factor, 0.65, 1.8)
