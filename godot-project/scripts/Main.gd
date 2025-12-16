extends Node2D

@onready var global = get_node("/root/Global")
@onready var player = $Player

func _ready():
    global.reset_game_data()
    # Connect signals for game end (victory/defeat)
    player.connect("game_over", self, "_on_game_over")
    player.connect("level_complete", self, "_on_level_complete")

func _on_game_over():
    # Save score and show defeat screen
    global.score = player.score
    global.coins = player.coins
    global.lives = player.lives
    global.update_last_played()
    global.save_score()
    global.save_custom_data()
    get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func _on_level_complete():
    # Save score and show victory screen
    global.score = player.score
    global.coins = player.coins
    global.lives = player.lives
    global.update_last_played()
    global.save_score()
    global.save_custom_data()
    get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")