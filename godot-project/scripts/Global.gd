extends Node

@export var game_id: String = "treasure-dash-001"

var player_name: String = "Player"
var score: int = 0
var coins: int = 0
var lives: int = 3

var leaderboard: Array = []

signal leaderboard_updated()

func _ready():
    load_game_data()

func load_game_data():
    var js_code = "window.parent.postMessage({ type: 'applaa-game-load-data', gameId: '%s' }, '*');" % game_id
    JavaScriptBridge.eval(js_code)

func save_score():
    var js_code = "window.parent.postMessage({ type: 'applaa-game-save-score', gameId: '%s', playerName: '%s', score: %d }, '*');" % [game_id, player_name, score]
    JavaScriptBridge.eval(js_code)

func update_leaderboard(data: Dictionary):
    leaderboard.clear()
    if data.has("scores"):
        for entry in data["scores"]:
            leaderboard.append(entry)
        leaderboard.sort_custom(self, "_sort_scores_desc")
        if leaderboard.size() > 10:
            leaderboard = leaderboard.slice(0, 10)
    emit_signal("leaderboard_updated")

func _sort_scores_desc(a, b):
    return int(b["score"]) - int(a["score"])

func on_applaa_game_data_loaded(data: Dictionary):
    if data == null:
        return
    if data.has("lastPlayerName"):
        player_name = data["lastPlayerName"]
    if data.has("scores"):
        update_leaderboard(data)