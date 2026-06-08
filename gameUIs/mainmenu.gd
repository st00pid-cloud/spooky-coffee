extends Control

func _ready() -> void:
	$VBoxContainer/ButtonStart.pressed.connect(_on_start_pressed)
	$VBoxContainer/ButtonAbout.pressed.connect(_on_about_pressed)
	$VBoxContainer/ButtonExit.pressed.connect(_on_exit_pressed)

func _on_start_pressed() -> void:
	# Replace "res://levels/level_01.tscn" with your actual game scene path
	get_tree().change_scene_to_file("res://levels/level_01.tscn")

func _on_about_pressed() -> void:
	# Option A: change to a dedicated About scene
	get_tree().change_scene_to_file("res://ui/about.tscn")

	# Option B: show/hide an About panel that lives in this same scene
	# $AboutPanel.visible = !$AboutPanel.visible

func _on_exit_pressed() -> void:
	get_tree().quit()
