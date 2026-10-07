extends Control

const FARM_SCENE := "res://scenes/FarmWorldV01.tscn"
const TR := "tr"
const EN := "en"

var language := "tr"
var root_layer: Control
var content: Control
var logo: TextureRect
var title_label: Label

var tr := {
    "welcome": "YUSUF İLE ELİF: BEREKETLİ ÇİFTLİĞİ\nHOŞ GELDİNİZ!",
    "choose_language": "Dilinizi seçin",
    "choose_language_en": "Choose your language",
    "start": "OYUNA BAŞLA",
    "settings": "AYARLAR",
    "account": "HESAP",
    "about_game": "OYUN HAKKINDA",
    "about_company": "ŞİRKET HAKKINDA",
    "feedback": "FİKİR / ÖNERİ GÖNDER",
    "language": "DİL",
    "quality": "Grafik Kalitesi",
    "low": "Düşük",
    "medium": "Orta",
    "high": "Yüksek",
    "ultra": "Kalite",
    "sound": "Ses",
    "music": "Müzik",
    "effects": "Efektler",
    "google": "Google / Play Games ile giriş",
    "apple": "Apple ile giriş",
    "account_note": "Hesap ve bulut kayıt bağlantısı",
    "feedback_subject": "Bereketli Çiftliği - Öneri",
    "feedback_note": "Fikir, öneri veya hata bildiriminizi gönderin.",
    "game_about_text": "Küçük bir araziden büyük bir çiftliğe uzanan kendi hikâyeni oluştur. Ekinlerini yetiştir, hayvanlarına bak, ürünlerini üret ve yeni bölgeleri keşfet.",
    "company_about_text": "LUMORIX Gamer Studio, özgün karakterler, dünyalar ve hikâyeler içeren oyunlar geliştirmeyi amaçlar. Yusuf ile Elif: Bereketli Çiftliği bu dünyanın ilk adımlarından biridir.",
    "back": "GERİ",
    "close": "KAPAT",
    "saved": "Ayar kaydedildi.",
    "coming": "Bu bağlantı sonraki geliştirme aşamasında etkinleştirilecek.",
    "select_language": "Türkçe",
}

var en := {
    "welcome": "YUSUF & ELIF: BOUNTIFUL FARM\nWELCOME!",
    "choose_language": "Choose your language",
    "choose_language_en": "Choose your language",
    "start": "START GAME",
    "settings": "SETTINGS",
    "account": "ACCOUNT",
    "about_game": "ABOUT THE GAME",
    "about_company": "ABOUT THE COMPANY",
    "feedback": "SEND FEEDBACK",
    "language": "LANGUAGE",
    "quality": "Graphics Quality",
    "low": "Low",
    "medium": "Medium",
    "high": "High",
    "ultra": "Quality",
    "sound": "Sound",
    "music": "Music",
    "effects": "Effects",
    "google": "Sign in with Google / Play Games",
    "apple": "Sign in with Apple",
    "account_note": "Account and cloud save connection",
    "feedback_subject": "Bountiful Farm - Feedback",
    "feedback_note": "Send your idea, suggestion or bug report.",
    "game_about_text": "Build your own story from a small piece of land to a thriving farm. Grow crops, care for animals, make products and discover new regions.",
    "company_about_text": "LUMORIX Gamer Studio aims to create games with original characters, worlds and stories. Yusuf & Elif: Bountiful Farm is one of the first steps in that world.",
    "back": "BACK",
    "close": "CLOSE",
    "saved": "Setting saved.",
    "coming": "This connection will be enabled in a later development stage.",
    "select_language": "English",
}

func _ready() -> void:
    _show_studio_splash()

func T(key: String) -> String:
    var table: Dictionary = en if language == EN else tr
    return str(table.get(key, key))

func _clear() -> void:
    for child in get_children():
        child.queue_free()

func _make_bg() -> ColorRect:
    var bg := ColorRect.new()
    bg.color = Color("#10251a")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)
    return bg

func _make_center() -> VBoxContainer:
    var box := VBoxContainer.new()
    box.alignment = BoxContainer.ALIGNMENT_CENTER
    box.add_theme_constant_override("separation", 18)
    box.set_anchors_preset(Control.PRESET_CENTER)
    box.position = Vector2(-260, -250)
    box.size = Vector2(520, 500)
    add_child(box)
    return box

func _logo(path: String, box: Control, h := 250) -> void:
    var r := TextureRect.new()
    r.texture = load(path)
    r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    r.custom_minimum_size = Vector2(520, h)
    box.add_child(r)

func _label(text_value: String, size := 28) -> Label:
    var l := Label.new()
    l.text = text_value
    l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    l.add_theme_font_size_override("font_size", size)
    l.add_theme_color_override("font_color", Color("#fff4d6"))
    return l

func _button(text_value: String, callback: Callable) -> Button:
    var b := Button.new()
    b.text = text_value
    b.custom_minimum_size = Vector2(420, 62)
    b.add_theme_font_size_override("font_size", 22)
    b.pressed.connect(callback)
    return b

func _show_studio_splash() -> void:
    _clear()
    _make_bg()
    var box := _make_center()
    _logo("res://Assets/UI/lumorix_logo.svg", box, 330)
    var t := _label("LUMORIX\nGamer Studio", 30)
    box.add_child(t)
    await get_tree().create_timer(1.0).timeout
    _show_welcome()

func _show_welcome() -> void:
    _clear()
    _make_bg()
    var box := _make_center()
    _logo("res://Assets/UI/game_logo.svg", box, 330)
    var t := _label(T("welcome"), 28)
    box.add_child(t)
    await get_tree().create_timer(2.2).timeout
    _show_language_select()

func _show_language_select() -> void:
    _clear()
    _make_bg()
    var box := _make_center()
    box.add_child(_label(T("choose_language") + " / " + T("choose_language_en"), 30))
    box.add_spacer(false)
    box.add_child(_button("🇹🇷  Türkçe", func(): _set_language(TR)))
    box.add_child(_button("🇬🇧  English", func(): _set_language(EN)))

func _set_language(value: String) -> void:
    language = value
    _show_main_menu()

func _show_main_menu() -> void:
    _clear()
    _make_bg()
    var box := _make_center()
    _logo("res://Assets/UI/game_logo.svg", box, 220)
    box.add_child(_button(T("start"), func(): get_tree().change_scene_to_file(FARM_SCENE)))
    box.add_child(_button("⚙  " + T("settings"), _show_settings))
    box.add_child(_button("👤  " + T("account"), _show_account))
    box.add_child(_button("💡  " + T("feedback"), _send_feedback))
    box.add_child(_button("ℹ  " + T("about_game"), _show_game_about))
    box.add_child(_button("🏢  " + T("about_company"), _show_company_about))
    var lang := _button("🌐  " + T("language") + ": " + T("select_language"), _show_language_select)
    box.add_child(lang)

func _panel(title: String) -> VBoxContainer:
    _clear()
    _make_bg()
    var box := _make_center()
    box.add_child(_label(title, 32))
    return box

func _back_button(box: VBoxContainer) -> void:
    box.add_spacer(false)
    box.add_child(_button(T("back"), _show_main_menu))

func _show_settings() -> void:
    var box := _panel(T("settings"))
    box.add_child(_label(T("quality"), 22))
    var q := OptionButton.new()
    q.custom_minimum_size = Vector2(420, 56)
    for k in ["low", "medium", "high", "ultra"]: q.add_item(T(k))
    q.select(1)
    q.item_selected.connect(func(index): _quality_changed(index))
    box.add_child(q)
    box.add_child(_button("🔊  " + T("sound"), func(): pass))
    box.add_child(_button("🎵  " + T("music"), func(): pass))
    box.add_child(_button("✨  " + T("effects"), func(): pass))
    _back_button(box)

func _quality_changed(index: int) -> void:
    var names := ["low", "medium", "high", "ultra"]
    if index >= 0 and index < names.size():
        ProjectSettings.set_setting("display/window/quality", names[index])
        ProjectSettings.save()

func _show_account() -> void:
    var box := _panel(T("account"))
    box.add_child(_label(T("account_note"), 18))
    box.add_child(_button("▶  " + T("google"), func(): _show_notice(T("coming"))))
    box.add_child(_button("  " + T("apple"), func(): _show_notice(T("coming"))))
    _back_button(box)

func _show_notice(message: String) -> void:
    var box := _panel(T("account"))
    box.add_child(_label(message, 20))
    _back_button(box)

func _send_feedback() -> void:
    var url := "mailto:LumorixGame@gmail.com?subject=" + T("feedback_subject").uri_encode() + "&body=" + T("feedback_note").uri_encode()
    OS.shell_open(url)

func _show_game_about() -> void:
    var box := _panel(T("about_game"))
    var l := _label(T("game_about_text"), 20)
    l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    box.add_child(l)
    _back_button(box)

func _show_company_about() -> void:
    var box := _panel(T("about_company"))
    var l := _label(T("company_about_text"), 20)
    l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    box.add_child(l)
    _back_button(box)
