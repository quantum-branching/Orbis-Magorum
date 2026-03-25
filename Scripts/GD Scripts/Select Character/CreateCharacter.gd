extends TextureButton
var Class:int = 0
var Race:int = 0

func _process(_delta:float) -> void:
	RenderingServer.global_shader_parameter_set("BootColor",Global.CallClassColor(Class))
	RenderingServer.global_shader_parameter_set("ChestColor",Global.CallClassColor(Class))
	RenderingServer.global_shader_parameter_set("HatColor",Global.CallClassColor(Class))
	RenderingServer.global_shader_parameter_set("ArmorType",Global.CallClassArmor(Class))
	var Error:String = ""
	if $"../Name".text == "":
		Error = "Name"
	if Class == 0:
		Error = "Class"
	if Race == 0:
		Error = "Race"
	if Error:
		$".".disabled = true
	else:
		$".".disabled = false

func _pressed():
	_process(0.0)
	if disabled:
		return
	Global.Names.append($"../Name".text)
	$"../Name".text = ""
	Global.ClassNo.append(Class)
	Global.RaceNo.append(Race)
	var TempInt:int = Global.CallMaxHP(Class)
	Global.HP.append(TempInt)
	Global.HPMax.append(TempInt)
	TempInt = Global.CallMaxMana(Class)
	Global.Mana.append(TempInt)
	Global.ManaMax.append(TempInt)
	Global.Pos.append(Vector2(0,0))
	Global.Dead.append(false)
	get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/Characters.tscn")
