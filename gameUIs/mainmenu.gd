extends Control
@onready var startButton : Button = $ColorRect/CenterContainer/VBoxContainer/START
@onready var aboutButton : Button = $ColorRect/CenterContainer/VBoxContainer/ABOUT
@onready var exitButton : Button = $ColorRect/CenterContainer/VBoxContainer/EXIT

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://gameItself/master-scene/maingameplay.tscn")

func _on_about_pressed() -> void:
	# No dedicated about scene yet. 
	get_tree().change_scene_to_file("res://gameUIs/ked-about.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
