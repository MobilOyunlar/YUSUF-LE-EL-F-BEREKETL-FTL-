extends Node3D

# Bereketli Çiftliği - Visual Farm V1.1
# Lightweight 3D farm scene using the original starter GLB assets.

func _ready() -> void:
    var camera := $Camera3D
    camera.look_at(Vector3(0, 0, 1.5), Vector3.UP)
    _build_ui()

func _build_ui() -> void:
    var root := $UI

    var title := Label.new()
    title.position = Vector2(28, 20)
    title.text = "YUSUF İLE ELİF: BEREKETLİ ÇİFTLİĞİ"
    title.add_theme_font_size_override("font_size", 25)
    root.add_child(title)

    var status := Label.new()
    status.position = Vector2(30, 58)
    status.text = "Çiftliğinize hoş geldiniz!  •  Seviye %d  •  Para %d  •  Elmas %d" % [
        GameData.player.level, GameData.player.coins, GameData.player.diamonds
    ]
    status.add_theme_font_size_override("font_size", 17)
    root.add_child(status)

    var hint := Label.new()
    hint.position = Vector2(30, 92)
    hint.text = "Yusuf ve Elif'in dededen kalan çiftliği  •  İlk hasadımıza başlayalım!"
    hint.add_theme_font_size_override("font_size", 15)
    root.add_child(hint)

    var farm_state := Label.new()
    farm_state.position = Vector2(30, 128)
    farm_state.text = "● ÇİFTLİK ÇEKİRDEĞİ AKTİF"
    farm_state.add_theme_font_size_override("font_size", 18)
    root.add_child(farm_state)

    var bottom := Label.new()
    bottom.position = Vector2(30, 675)
    bottom.text = "🌾 TARLA    🐄 HAYVANLAR    🏭 ÜRETİM    💰 EKONOMİ    🏡 DEKORASYON"
    bottom.add_theme_font_size_override("font_size", 16)
    root.add_child(bottom)
