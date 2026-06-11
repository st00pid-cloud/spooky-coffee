extends Control
@onready var startButton : Button = $ColorRect/CenterContainer/VBoxContainer/START
@onready var aboutButton : Button = $ColorRect/CenterContainer/VBoxContainer/ABOUT
@onready var exitButton : Button = $ColorRect/CenterContainer/VBoxContainer/EXIT

func _on_start_pressed() -> void:
	# Replace "res://levels/level_01.tscn" with your actual game scene path
	get_tree().change_scene_to_file("res://gameItself/master-scene/maingameplay.tscn")

func _on_about_pressed() -> void:
	# Option A: change to a dedicated About scene
	get_tree().change_scene_to_file("res://ui/about.tscn")

	# Option B: show/hide an About panel that lives in this same scene
	# $AboutPanel.visible = !$AboutPanel.visible
func _on_exit_pressed() -> void:
	get_tree().quit()
