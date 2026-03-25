extends Label
var CharacterNo:int = 0
var Name:String = "";
var Class:int = 0
var Race:int = 0
var ClassString:String = "";
var RaceString:String = "";
var HealthString:String = "";
var ClassColor:Color = Color("ffffff")

func _process(_delta):
	#Change Character
	if Input.is_action_just_pressed("ui_left"):
		if CharacterNo > 0:
			CharacterNo -= 1
	if Input.is_action_just_pressed("ui_right"):
		if CharacterNo+1 < len(Global.Names):
			CharacterNo += 1
	#Set Character Information
	Name = Global.Names[CharacterNo]
	Class = Global.ClassNo[CharacterNo]
	Race = Global.RaceNo[CharacterNo]
	ClassString = Global.ClassFromNo(Class)
	RaceString = Global.RaceFromNo(Race)
	HealthString = str(int(Global.HP[CharacterNo]))+"/"+str(int(Global.HPMax[CharacterNo]))
	if Global.Dead[CharacterNo]:
		HealthString = HealthString + " (Dead)"
	text = "".join(["Name: ",Name,"\nClass: ",ClassString,"\nRace: ",RaceString,"\nHP: ",HealthString])
	ClassColor = Global.CallClassColor(Class)
	#Set Center Character Color
	ClassColor = Global.CallClassColor(Class)
	RenderingServer.global_shader_parameter_set("BootColor",ClassColor)
	RenderingServer.global_shader_parameter_set("ChestColor",ClassColor)
	RenderingServer.global_shader_parameter_set("HatColor",ClassColor)
	RenderingServer.global_shader_parameter_set("ArmorType",Global.CallClassArmor(Class))
	#Set Left Character Color
	$"../PlayerL".visible = CharacterNo > 0
	if CharacterNo > 0:
		Class = Global.ClassNo[CharacterNo-1]
		ClassColor = Global.CallClassColor(Class)
		$"../PlayerL".material.set_shader_parameter("BootColorOverride",ClassColor)
		$"../PlayerL".material.set_shader_parameter("ChestColorOverride",ClassColor)
		$"../PlayerL".material.set_shader_parameter("HatColorOverride",ClassColor)
		$"../PlayerL".material.set_shader_parameter("ArmorTypeOverride",Global.CallClassArmor(Class))
	$"../PlayerR".visible = (len(Global.ClassNo) > CharacterNo + 1)
	if len(Global.ClassNo) > CharacterNo + 1:
		Class = Global.ClassNo[CharacterNo+1]
		ClassColor = Global.CallClassColor(Class)
		$"../PlayerR".material.set_shader_parameter("BootColorOverride",ClassColor)
		$"../PlayerR".material.set_shader_parameter("ChestColorOverride",ClassColor)
		$"../PlayerR".material.set_shader_parameter("HatColorOverride",ClassColor)
		$"../PlayerR".material.set_shader_parameter("ArmorTypeOverride",Global.CallClassArmor(Class))
