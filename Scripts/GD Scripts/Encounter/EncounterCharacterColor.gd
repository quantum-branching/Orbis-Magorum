@icon("res://Images/Character/BaseCharacter.png")
extends Sprite2D
func _ready():
	var ClassColor = Global.CallClassColor(Character.ClassNo)
	$"Left Foot".self_modulate = ClassColor
	$"Right Foot".self_modulate = ClassColor
	$Chest.self_modulate = ClassColor
	$Hair.self_modulate = Color(.5,.25,0)
	$Hat.self_modulate = ClassColor
