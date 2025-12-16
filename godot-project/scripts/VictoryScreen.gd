extends Control

@onready var global = get_node("/root/Global")

func _ready():
    $VBoxContainer/ScoreLabel.text = "Final Score: %d" % global.score
    $VBoxContainer/CoinsLabel.text = "Coins Collected: %d" % global.coins
    $VBoxContainer/PlayerNameLabel.text = "Player: %s" % global.player_name
    update_leaderboard_ui()
    $VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
    $VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
    $VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)

func update_leaderboard_ui():
    var lb = $VBoxContainer/Leaderboard
    lb.clear()
    for entry in global.leaderboard:
        var text = "%s - %d" % [entry["playerName"], int(entry["score"])]
        lb.add_item(text)

func _on_restart_pressed():
    global.reset_game_data()
    get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed():
    global.reset_game_data()
    get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
    get_tree().quit()