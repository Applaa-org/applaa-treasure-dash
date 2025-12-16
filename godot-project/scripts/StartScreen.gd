extends Control

@onready var global = get_node("/root/Global")

func _ready():
    $VBoxContainer/StartButton.pressed.connect(_on_start_pressed)
    $VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)
    $VBoxContainer/NameLineEdit.text = global.player_name

func _on_start_pressed():
    var name = $VBoxContainer/NameLineEdit.text.strip_edges()
    if name == "":
        name = "Guest"
    global.player_name = name
    global.update_last_played()
    global.save_custom_data()
    get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
    get_tree().quit()