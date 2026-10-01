extends Node

var language := "tr"
var strings := {}

func set_language(lang: String):
    language = lang

func tr(key: String) -> String:
    if strings.has(key):
        return strings[key].get(language, key)
    return key
