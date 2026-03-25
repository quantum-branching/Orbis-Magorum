extends TextureButton

func _process(_delta):
	if len(Global.Pos) == 0:
		disabled =  true
	else:
		disabled = Global.Dead[$"../CharacterLabel".CharacterNo]

func _pressed():
	if len(Global.Pos) > 0:
		Character.OpenCharacter = $"../CharacterLabel".CharacterNo + 1
		Character.CallInfo(Character.OpenCharacter)
		get_tree().change_scene_to_file("res://Scripts/GD Scripts/Play/Play.tscn")
