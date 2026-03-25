@icon("res://Images/Character/Slime.png")
extends Sprite2D
var HP:float = 0
var Damage:float = 2

func _ready():
	HP = 75
func _process(_delta):
	Damage = 5*Global.Difficulty
	$"../OppHP Bar".value = HP
	$"../OppHP Bar".tint_progress = Color(min(2-HP/50,1),min(HP/50,1),0)
	$"../OppHP Bar/OppHP Label".text = " ".join(["HP:",int(HP),"/ 75"])
	if HP <= 0:
		Character.InEncounter = false
		Character.ClassNo = abs(Character.ClassNo)
		get_tree().change_scene_to_file("res://Scripts/GD Scripts/Play/Play.tscn")
	if Character.HP <= 0:
		Character.HP = 0
		Character.Dead = true
		Character.SetInfo(Character.OpenCharacter)
		Character.InEncounter = false
		Character.ClassNo = abs(Character.ClassNo)
		if Global.Resources[0]:
			get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/Characters.tscn")
		else:
			get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/LegacyCharacters.tscn")
