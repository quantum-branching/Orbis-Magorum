extends Sprite2D
var CharacterMoving:bool = false
var MovingTimer:float = 0
var MovementSpeed:float = 5.0
var MovingSideways:bool = false
var EncounterChance:int = 2
var Debug:bool = false
var PlayerPos:Vector2 = Vector2(0,0)
@export var MapTexture:Texture2D
@export var EncounterNoise:Texture2D
var EncounterNoiseImage:Image
var Map:Image

var UpTexture:Texture2D
var DownTexture:Texture2D
var SideTexture:Texture2D
var Moving:bool = false
var SwapFloat:float = 0.0
var Direction:int = 0
var Swap:int = 0
var QueuePos:Vector2 = Vector2(0,0)

func _ready():
	PlayerPos = Character.Pos
	RenderingServer.global_shader_parameter_set("BootColor",Global.CallClassColor(Character.ClassNo))
	RenderingServer.global_shader_parameter_set("ChestColor",Global.CallClassColor(Character.ClassNo))
	RenderingServer.global_shader_parameter_set("HatColor",Global.CallClassColor(Character.ClassNo))
	RenderingServer.global_shader_parameter_set("ArmorType",Global.CallClassArmor(Character.ClassNo))
	UpTexture = load("res://Images/Character/CharacterBack.webp")
	DownTexture = load("res://Images/Character/CharacterFront.webp")
	SideTexture = load("res://Images/Character/CharacterSide.webp")
	Map = MapTexture.get_image()
	EncounterNoiseImage = EncounterNoise.get_image()

func _process(delta):
	Character.SetInfo(Character.OpenCharacter)
	if Input.is_action_just_pressed("M"):
		get_tree().change_scene_to_file("res://Scripts/GD Scripts/Map/Map.tscn")
	moving(delta)

##Checks to see if the player randomly encounters an enemy when inside encounter blocks.
func runEncounter():
	if fmod(Global.GlobalTime,60)<45:
		EncounterChance = 2
	else:
		EncounterChance = 8
	if randi_range(0,20) <= 2:
		if Character.InTall == true:
			Character.InEncounter = true
			get_tree().change_scene_to_file("res://Scripts/GD Scripts/Encounter/Encounter.tscn")

##Checks to see whether the player is in an encounter block.
func EncounterBlocks():
	var EncounterPixel = EncounterNoiseImage.get_pixel((238+int(PlayerPos.x))%128,(238+int(PlayerPos.y))%128)
	var MapPixel = Map.get_pixel(int(PlayerPos.x+QueuePos.x+238),int(PlayerPos.y+QueuePos.y+238))
	if EncounterPixel.r < .25 && MapPixel.b > .1:
		Character.InTall = true
	else:
		Character.InTall = false
##Allows the character to control their character.
func moving(delta):
	Moving = false
	if Input.is_action_pressed("Up"):
		QueuePos.y = -MovementSpeed*delta
		if Direction != 1:
			texture = UpTexture
			Direction = 1
	elif Input.is_action_pressed("Left"):
		QueuePos.x = -MovementSpeed*delta
		if Direction != 2:
			texture = SideTexture
			scale.x = -abs(scale.x)
			Direction = 2
	elif Input.is_action_pressed("Right"):
		QueuePos.x = MovementSpeed*delta
		if Direction != 4:
			texture = SideTexture
			scale.x = abs(scale.x)
			Direction = 4
	elif Input.is_action_pressed("Down"):
		QueuePos.y = MovementSpeed*delta
		if Direction != 3:
			texture = DownTexture
			scale.x = abs(scale.x)
			Direction = 3
	if QueuePos != Vector2(0,0):
		Moving = true
		var pixel = Map.get_pixel(int(PlayerPos.x+QueuePos.x+238),int(PlayerPos.y+QueuePos.y+238)).g
		if pixel > .25 && pixel < .75:
			PlayerPos += QueuePos
			if Vector2i(Character.Pos) != Vector2i(PlayerPos):
				EncounterBlocks()
				runEncounter()
			Character.Pos = PlayerPos
		QueuePos = Vector2(0,0)
	if Moving:
		SwapFloat += 3.0*delta
	if SwapFloat >= 2:
		SwapFloat = 0
	if fmod(SwapFloat,1) < .25:
		Swap = 0
	else:
		Swap = 1+int(SwapFloat)
	if !Moving:
		Swap = 0
	RenderingServer.global_shader_parameter_set("Swap",Swap)
	RenderingServer.global_shader_parameter_set("Pos",Vector2i(PlayerPos))
