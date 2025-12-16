extends Node

@onready var global = get_node("/root/Global")

func _ready():
    if Engine.has_singleton("JavaScript"):
        var js = Engine.get_singleton("JavaScript")
        js.connect("message", Callable(self, "_on_js_message"))

func _on_js_message(message):
    if typeof(message) == TYPE_DICTIONARY:
        if message.has("type") and message["type"] == "applaa-game-data-loaded":
            var data = message.get("data", null)
            global.on_applaa_game_data_loaded(data)