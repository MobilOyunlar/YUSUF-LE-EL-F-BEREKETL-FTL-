extends Node

var game_version := "1.0.0"
var language := "tr"

var settings := {
        "language": "tr",
        "graphics_quality": "medium",
        "sound_enabled": true,
        "music_enabled": true,
        "effects_enabled": true
}

var player := {
	"level": 1,
	"coins": 1000,
	"diamonds": 50,
	"xp": 0,

	# Temel çiftlik kaynakları.
	"wood": 100,
	"stone": 100,
	"iron": 50,

	# Arazi ilerleme durumu.
	"farm_size": 12
}
