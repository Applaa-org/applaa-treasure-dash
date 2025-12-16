extends Node

@onready var global = get_node("/root/Global")

func _ready():
    # Connect to JavaScript postMessage events
    if Engine.has_singleton("JavaScript"):
        var js = Engine.get_singleton("JavaScript")
        js.connect("message", Callable(self, "_on_js_message"))
    else:
        # For HTML5 export, listen to window messages
        JavaScriptBridge.eval("""
            window.addEventListener('message', function(event) {
                if(event.data && event.data.type === 'applaa-game-data-loaded') {
                    godotInstance.send_message('applaa-game-data-loaded', event.data.data);
                }
            });
        """)

func _on_js_message(message):
    if typeof(message) == TYPE_DICTIONARY:
        if message.has("type") and message["type"] == "applaa-game-data-loaded":
            var data = message.get("data", null)
            global.on_applaa_game_data_loaded(data)