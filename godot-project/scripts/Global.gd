extends Node

@export var game_id: String = "treasure-dash-001"

var player_name: String = "Guest"
var score: int = 0
var coins: int = 0
var lives: int = 3
var levels_unlocked: int = 1
var last_played: String = ""

var leaderboard: Array = []

signal leaderboard_updated()

func _ready():
    # Load saved data from Applaa storage
    load_game_data()

func load_game_data():
    # Request game data from Applaa platform
    var js_code = "window.parent.postMessage({ type: 'applaa-game-load-data', gameId: '%s' }, '*');" % game_id
    JavaScriptBridge.eval(js_code)

func save_score():
    # Save current player score and data to Applaa platform
    var js_code = "window.parent.postMessage({ type: 'applaa-game-save-score', gameId: '%s', playerName: '%s', score: %d }, '*');" % [game_id, player_name, score]
    JavaScriptBridge.eval(js_code)

func save_custom_data():
    # Save other custom data like coins, levels unlocked, last played date
    var data = {
        "coins": coins,
        "levelsUnlocked": levels_unlocked,
        "lastPlayed": last_played
    }
    var json_data = to_json(data)
    var js_code = "window.parent.postMessage({ type: 'applaa-game-save-data', gameId: '%s', data: %s }, '*');" % [game_id, json_data]
    JavaScriptBridge.eval(js_code)

func update_last_played():
    last_played = OS.get_datetime().to_string()

func reset_game_data():
    score = 0
    coins = 0
    lives = 3

func update_leaderboard(data: Dictionary):
    # data.scores is an array of {playerName, score, timestamp}
    leaderboard.clear()
    if data.has("scores"):
        for entry in data["scores"]:
            leaderboard.append(entry)
        # Sort descending by score
        leaderboard.sort_custom(self, "_sort_scores_desc")
        # Keep top 10
        if leaderboard.size() > 10:
            leaderboard = leaderboard.slice(0, 10)
    emit_signal("leaderboard_updated")

func _sort_scores_desc(a, b):
    return int(b["score"]) - int(a["score"])

# Called from JavaScript message handler in Loader or main scene
func on_applaa_game_data_loaded(data: Dictionary):
    if data == null:
        return
    if data.has("lastPlayerName"):
        player_name = data["lastPlayerName"]
    if data.has("scores"):
        update_leaderboard(data)
    if data.has("customData"):
        var cd = data["customData"]
        if cd.has("coins"):
            coins = int(cd["coins"])
        if cd.has("levelsUnlocked"):
            levels_unlocked = int(cd["levelsUnlocked"])
        if cd.has("lastPlayed"):
            last_played = cd["lastPlayed"]

func get_top_score() -> int:
    if leaderboard.size() > 0:
        return int(leaderboard[0]["score"])
    return 0

func get_top_player() -> String:
    if leaderboard.size() > 0:
        return leaderboard[0]["playerName"]
    return ""