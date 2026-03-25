@icon("res://Images/Icons/TextIcon.png")
extends TouchScreenButton
func _process(_delta):
	if Input.is_action_just_released("Escape"):
		get_tree().change_scene_to_file("res://Scripts/GD Scripts/Play/Play.tscn")
