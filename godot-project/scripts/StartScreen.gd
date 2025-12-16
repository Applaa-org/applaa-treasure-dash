extends Control

@onready var global = get_node("/root/Global")

func _ready():
    $VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
    $VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)
    $VBoxContainer/NameLineEdit.text = global.player_name

func _on_start_pressed():
    var name = $VBoxContainer/NameLineEdit.text.strip_edges()
    if name == "":
        name = "Player"
    global.player_name = name
    global.save_score() # Save initial score 0 with player name
    get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
    get_tree().quit()