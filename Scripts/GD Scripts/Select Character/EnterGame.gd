@icon("res://Images/Icons/ButtonIcon.png")
extends TextureButton

func _process(_delta):
	disabled = Global.Dead[$"../Saved Characters".selected]

func _pressed():
	if len(Global.Pos) > 0:
		get_tree().change_scene_to_file("res://Scripts/GD Scripts/Play/Play.tscn")
