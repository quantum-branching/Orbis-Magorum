extends Node
#region Saved Information
##A single element of [member Global.Names] that signifies the Name of the current character.
var Names :String = ""
##A single element of [member Global.ClassNo] that signifies the ClassNo of the current character.
var ClassNo :int = 0
##A single element of [member Global.RaceNo] that signifies the RaceNo of the current character.
var RaceNo :int = 0
##A single element of [member Global.HP] that signifies the HP of the current character.
var HP :float = 0
##A single element of [member Global.HPMax] that signifies the HPMax of the current character.
var HPMax :int = 0
##A single element of [member Global.Mana] that signifies the Mana of the current character.
var Mana :float = 0
##A single element of [member Global.ManaMax] that signifies the ManaMax of the current character.
var ManaMax :int = 0
##A single element of [Global].Pos that signifies the Pos of the current character.
var Pos :Vector2 = Vector2(0,0)
##A single element of [Global].Dead that signifies the death status of the current character.
var Dead:bool = false
#endregion

#region Calculate Every Frame
##Determines whether or not the character is in an encounter.
var InEncounter:bool = false
##Controls whether or not the character is in tall grass or an equivalent. This can cause the character to be in an encounter.
var InTall:bool = false
##Determines whether or not the character is in water.
var InWater:bool = false
##Determines what direction the character is moving in.
var MovementVec:Vector2 = Vector2(0,0)
##Used for determining whether or not to update the position for shaders.
var PosUpdateTimer:float = 0

#endregion

#region Other Variables
##Value used to transfer information for saving.
var OpenCharacter :int = 0

#endregion

#region Custom Functions
##Calls Global Information to set Local Information. [br][br][b]Example: [/b][codeblock]CallInfo(OpenCharacter)
##print("Names",Names)
##print("ClassNo",ClassNo)
##print("RaceNo",RaceNo)
##print("HP",HP)
##print("HPMax",HPMax)
##print("Mana",Mana)
##print("MaxMana",MaxMana)
##print("Pos",Pos)
##print("Dead",Dead)[/codeblock]
func CallInfo(CharacterNumber:int) -> void:
	Names = Global.Names[CharacterNumber-1]
	ClassNo = Global.ClassNo[CharacterNumber-1]
	RaceNo = Global.RaceNo[CharacterNumber-1]
	HP = Global.HP[CharacterNumber-1]
	HPMax = Global.HPMax[CharacterNumber-1]
	Mana = Global.Mana[CharacterNumber-1]
	ManaMax = Global.ManaMax[CharacterNumber-1]
	Pos = Global.Pos[CharacterNumber-1]
	Dead = Global.Dead[CharacterNumber-1]

##Sets Global Information to Local Information. [br][br][b]Example: [/b][codeblock]SetInfo(OpenCharacter)[/codeblock]
func SetInfo(CharacterNumber:int) -> void:
	Global.ClassNo[CharacterNumber-1] = ClassNo
	Global.RaceNo[CharacterNumber-1] = RaceNo
	Global.HP[CharacterNumber-1] = HP
	Global.HPMax[CharacterNumber-1] = HPMax
	Global.Mana[CharacterNumber-1] = Mana
	Global.ManaMax[CharacterNumber-1] = ManaMax
	Global.Pos[CharacterNumber-1] = Pos
	Global.Dead[CharacterNumber-1] = Dead

#endregion

#region Built-in Functions
func _process(delta):
	#Timer
	PosUpdateTimer = PosUpdateTimer + delta
	if PosUpdateTimer > 0.01:
		RenderingServer.global_shader_parameter_set("Pos",Vector2i(Pos))
		PosUpdateTimer = 0
	#Regenerate Health/Mana
	if not InEncounter:
		if HP < HPMax:
			HP = HP + 0.025*HPMax*delta
			if HP > HPMax:
				HP = HPMax
		if Mana < ManaMax:
			Mana = Mana + 0.025*ManaMax*delta
			if Mana > ManaMax:
				Mana = ManaMax
	for i in range(len(Global.Dead)):
		if Global.Dead[i]:
			Global.HP[i] += 0.025*Global.HPMax[i]*delta
			if Global.HP[i] >= Global.HPMax[i]:
				Global.Dead[i] = false
				Global.HP[i] = Global.HPMax[i]

#endregion
