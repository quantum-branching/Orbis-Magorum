@icon("res://Images/Icons/TextIcon.png")
extends TouchScreenButton
func _process(_delta):
	if Input.is_action_just_pressed("Escape"):
		if Global.NewCharacterMod == true:
			get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/Characters.tscn")
		else:
			get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/LegacyCharacters.tscn")
