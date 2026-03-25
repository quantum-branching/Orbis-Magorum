##This class is the central node that contains all save information and processes these saves.
extends Node
#region Character Transfer Information
## A list of Names that gets saved to a save file via [member Global.savegame()].
var Names:Array = []
## A list of ClassNo that gets saved to a save file via [member Global.savegame()].
var ClassNo:Array = []
## A list of RaceNo that gets saved to a save file via [member Global.savegame()].
var RaceNo:Array = []
## A list of HP that gets saved to a save file via [member Global.savegame()].
var HP:Array = []
## A list of HPMax that gets saved to a save file via [member Global.savegame()].
var HPMax:Array = []
## A list of Mana that gets saved to a save file via [member Global.savegame()].
var Mana:Array = []
## A list of ManaMax that gets saved to a save file via [member Global.savegame()].
var ManaMax:Array = []
## A list of Pos that gets saved to a save file via [member Global.savegame()].
var Pos:Array = []
##A list of each characters status of death which gets saved to a save file via [member Global.savegame()].
var Dead:Array = []

#endregion

#region Setting Values
##Setting that controls the rate at which a user can make combat unfold. Default is 1 which equates to one action taking atleast three seconds. Maximum value is 10.
var CombatSpeed :float = 1
##Setting that controls the rate at which the map loads. The higher the more of the map is loaded in one frame, however this slows down each frame.
var MapLoadingSpeed:int = 1
##This is the path that the savefile is saved under. This is currently in the format of "v"+hex(Major)+"x"+hex(MinorMinor) [br][br][b]Note: [/b]This setting is currently not implemented.
var save_path = "user://v1x09x0.PxlMgc"
##This is the current version of the game. Any code that references this variable is dependent on the game version and is often used for compatibility so that old game saves will not be corrupted. This variable should be written in hexadecimal (or the corresponding decimal equivalent) of 0x[Major]_[2xMinor]_[1xPatch]
var GameVersion:int = 0x1_0B_0
##This is the mean brightness of the game, any color value with a brightness above this will be increased and any color value with a brightness below this value will be decreased.
var Brightness:float = 0.5
##This value is the player chosen difficulty.
var DifficultySetting:float = 0.0
##Possible values for the variables [member Renderer].
enum RendererEnums{
	##The CPU Renderer only performs operations to generate terrain when creating a texture of the entire map (this requires a loading time).
	CPU_RENDERER,
	##The GPU Renderer performs terrain operations on every pixel through the GPU every frame but does not require a loading time.
	GPU_RENDERER}
##The method of rendering terrain.
var Renderer:RendererEnums = RendererEnums.GPU_RENDERER
#endregion

#region Temp Settings
##Controls whether or not the FPS is shown. [br] -1 indicates that its visibility is based on Menu Screen's FPS indicator's visibility [br] 0 indicates that its visibility is false [br] 1 indicated that its visibility is true
var FPSVisible:int = -1
##This is the amount of time from the last save. If this number is great than one, then the global data will save to the save file. [br][br][b]Example:[/b][codeblock]func _process(delta):
##    TimeFromSave = TimeFromSave + delta
##    if TimeFromSave > 1:
##        savegame()
##        TimeFromSave = 0[/codeblock]
var TimeFromSave:float = 0.0
var GlobalTime:float = 0.0
var MapScaleMod:int = 1
var Difficulty:float = 1.0

#endregion

#region
var Resources:Array = []
var NewCharacterMod:bool = true
#endregion

#region Call New Character Functions

##Returns the name of a class from a class number.
func ClassFromNo(Number:int) -> String:
	if Number == 1:
		return "Druid"
	if Number == 2:
		return "Hunter"
	if Number == 3:
		return "Mage"
	if Number == 4:
		return "Paladin"
	if Number == 5:
		return "Priest"
	if Number == 6:
		return "Rogue"
	if Number == 7:
		return "Shaman"
	if Number == 8:
		return "Warlock"
	if Number == 9:
		return "Warrior"
	return "Unknown"

##Returns the name of a race from a race number.
func RaceFromNo(Number:int):
	if Number == 1:
		return "Gnome"
	if Number == 2:
		return "Dwarf"
	if Number == 3:
		return "Human"
	if Number == 4:
		return "Elf"

##Returns the Maximum Health of the specified class.
func CallMaxHP(ClassNumber:int):
	if ClassNumber == 1:
		return 80
	if ClassNumber == 2:
		return 80
	if ClassNumber == 3:
		return 60
	if ClassNumber == 4:
		return 90
	if ClassNumber == 5:
		return 70
	if ClassNumber == 6:
		return 70
	if ClassNumber == 7:
		return 90
	if ClassNumber == 8:
		return 70
	if ClassNumber == 9:
		return 100

##Returns the Maximum Mana of the specified class.
func CallMaxMana(ClassNumber:int):
	if ClassNumber == 1:
		return 70
	if ClassNumber == 2:
		return 60
	if ClassNumber == 3:
		return 100
	if ClassNumber == 4:
		return 80
	if ClassNumber == 5:
		return 90
	if ClassNumber == 6:
		return 60
	if ClassNumber == 7:
		return 80
	if ClassNumber == 8:
		return 90
	if ClassNumber == 9:
		return 40

##Returns the color of clothing for a specified class.
func CallClassColor(ClassNumber:int) -> Color:
	if ClassNumber == 1:
		return Color(.5,.25,0)
	if ClassNumber == 2:
		return Color(.25,.5,.25)
	if ClassNumber == 3:
		return Color(1,0,1)
	if ClassNumber == 4:
		return Color(.75,.75,.75)
	if ClassNumber == 5:
		return Color(1,1,.15)
	if ClassNumber == 6:
		return Color(0,.25,.25)
	if ClassNumber == 7:
		return Color(.5,0,1)
	if ClassNumber == 8:
		return Color(.375,0,.375)
	if ClassNumber == 9:
		return Color(.5,0,0)
	return Color(1,1,1)

##Returns the armor class for a specific class.
func CallClassArmor(ClassNumber:int) -> int:
	if ClassNumber == 1:
		return 2
	if ClassNumber == 2:
		return 3
	if ClassNumber == 3:
		return 1
	if ClassNumber == 4:
		return 4
	if ClassNumber == 5:
		return 1
	if ClassNumber == 6:
		return 2
	if ClassNumber == 7:
		return 3
	if ClassNumber == 8:
		return 1
	if ClassNumber == 9:
		return 4
	return -1

#endregion

#region Custom Functions

func ConvertStringArray(StringArray:PackedStringArray = [],Type:String = "int"):
	var NewArray:Array = []
	for i in range(len(StringArray)):
		if Type == "int":
			NewArray.append(int(StringArray[i]))
		if Type == "Vector2":
			if StringArray[i].contains(","):
				var Vec1:float = float(StringArray[i].split(",")[0])
				var Vec2:float = float(StringArray[i].split(",")[1])
				NewArray.append(Vector2(Vec1,Vec2))
			else:
				NewArray.append(Vector2(0,0))
	return NewArray

func ReadVar(File:FileAccess):
	return str_to_var(File.get_line())

func WriteVar(Variable,File:FileAccess) -> void:
	var Result = var_to_str(Variable)
	File.store_line(Result)

func ReduceFloatArray(array):
	var Result:Array = []
	for i in array:
		Result.append(int(i))
	return Result

func ReduceVec2Array(array):
	var Result:Array = []
	for i in array:
		Result.append(Vector2i(i))
	return Result

##This function clears all saved data from the global save data. [br][br][b]Note: [/b]This does not inherently clear data from the save file, but this cleared save data is often saved to the save file right after the global save data is cleared. [br][br][b]Example:[/b][codeblock]func clearsavefile():
##    resetsave()
##    savegame()[/codeblock]
func resetsave():
	Names = []
	ClassNo = []
	RaceNo = []
	HP = []
	HPMax = []
	Mana = []
	ManaMax = []
	Pos = []
	CombatSpeed = 1
	MapLoadingSpeed = 1
	Brightness = 50
	Resources = [true]
	DifficultySetting = 1.0
	Dead = []

##This function saves the global game data to the save file. [br][br][b]Example: [/b][codeblock]func _process():
##    savegame()[/codeblock]
func savegame():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	WriteVar(GameVersion,file)
	WriteVar(Names,file)
	WriteVar(ClassNo,file)
	WriteVar(RaceNo,file)
	WriteVar(ReduceFloatArray(HP),file)
	WriteVar(HPMax,file)
	WriteVar(ReduceFloatArray(Mana),file)
	WriteVar(ManaMax,file)
	WriteVar(ReduceVec2Array(Pos),file)
	WriteVar(CombatSpeed,file)
	WriteVar(MapLoadingSpeed,file)
	WriteVar(Brightness,file)
	WriteVar(Resources,file)
	WriteVar(DifficultySetting,file)
	WriteVar(Dead,file)
	file.flush()

##This function access the save file data and sets the global game data to its contents. [br][br][b]Example: [/b][codeblock]func _ready():
##    loadgame()[/codeblock]
func loadgame() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path,FileAccess.READ)
		GameVersion = ReadVar(file)
		Names = ReadVar(file)
		ClassNo = ReadVar(file)
		RaceNo = ReadVar(file)
		HP = ReadVar(file)
		HPMax = ReadVar(file)
		Mana = ReadVar(file)
		ManaMax = ReadVar(file)
		Pos = ReadVar(file)
		CombatSpeed = ReadVar(file)
		MapLoadingSpeed = ReadVar(file)
		Brightness = ReadVar(file)
		Resources = ReadVar(file)
		DifficultySetting = ReadVar(file)
		Dead = ReadVar(file)
		return
	if FileAccess.file_exists("user://TextSave.PxlMgc") || FileAccess.file_exists("user://v1x08x0.PxlMgc"):
		var file = FileAccess.open("user://TextSave.PxlMgc",FileAccess.READ)
		var LoadVersion = 0x1_07_0
		if FileAccess.file_exists("user://v1x08x0.PxlMgc"):
			file = FileAccess.open("user://v1x08x0.PxlMgc",FileAccess.READ)
			file.get_line()
			LoadVersion = 0x1_08_0
		Names = file.get_csv_line(",")
		ClassNo = ConvertStringArray(file.get_csv_line(","))
		RaceNo = ConvertStringArray(file.get_csv_line(","))
		HP = ConvertStringArray(file.get_csv_line(","))
		HPMax = ConvertStringArray(file.get_csv_line(","))
		Mana = ConvertStringArray(file.get_csv_line(","))
		ManaMax = ConvertStringArray(file.get_csv_line(","))
		Pos = ConvertStringArray(file.get_csv_line(","),"Vector2")
		CombatSpeed = int(file.get_line())
		MapLoadingSpeed = int(file.get_line())
		if LoadVersion < 0x1_08_0:
			MapLoadingSpeed = floor(MapLoadingSpeed/2.0)
		Brightness = float(file.get_line())
		Dead.resize(len(ClassNo))
		Dead.fill(false)
		return
	if FileAccess.file_exists("user://magic2d.save"):
		var file = FileAccess.open("user://magic2d.save",FileAccess.READ)
		Names = file.get_var()
		ClassNo = file.get_var()
		RaceNo = file.get_var()
		HP = file.get_var()
		HPMax = file.get_var()
		Mana = file.get_var()
		ManaMax = file.get_var()
		Pos = file.get_var()
		CombatSpeed = file.get_var()
		if file.get_position() < file.get_length():
			MapLoadingSpeed = file.get_var()
			MapLoadingSpeed = floor(MapLoadingSpeed/2.0)
		else:
			MapLoadingSpeed = 25
		return

#endregion

#region Built-in Functions
func _ready():
	loadgame()
	var ResLen = len(Resources)
	if ResLen >= 1:
		NewCharacterMod = Resources[0]
	Difficulty = 1.0 + .5*pow(DifficultySetting*1.1/4.0,pow(DifficultySetting*1.1/4.0,DifficultySetting*1.1))
	RenderingServer.global_shader_parameter_set("MeanBrightness",Brightness)

func _process(delta):
	if Input.is_action_just_pressed("F2"):
		get_viewport().get_texture().get_image().save_webp("user://Screenshot.webp")
	TimeFromSave = TimeFromSave + delta
	GlobalTime = GlobalTime + delta
	RenderingServer.global_shader_parameter_set("Time",GlobalTime)
	if TimeFromSave > 1:
		Resources = [NewCharacterMod]
		savegame()
		TimeFromSave = 0
#endregion
