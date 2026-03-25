extends Sprite2D
var PlayerPos:Vector2 = Vector2(0,0)
var MovementSpeed:float = 7.0
var UpTexture:Resource
var DownTexture:Resource
var SideTexture:Resource
var Moving:bool = false
var SwapFloat:float = 0.0
var Direction:int = 0
var Swap:int = 0
var QueuePos:Vector2 = Vector2(0,0)
var Map:Image

@export var MapTexture:Texture

func _ready():
	Map = MapTexture.get_image()
	UpTexture = load("res://Images/Character/CharacterBack.webp")
	DownTexture = load("res://Images/Character/CharacterFront.webp")
	SideTexture = load("res://Images/Character/CharacterSide.webp")

func _process(delta):
	Moving = false
	if Input.is_action_pressed("Up"):
		QueuePos.y = -MovementSpeed*delta
		if Direction != 1:
			texture = UpTexture
			scale.x = abs(scale.x)
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
		if Map.get_pixel(int(PlayerPos.x+QueuePos.x+238),int(PlayerPos.y+QueuePos.y+238)).s > 0:
			PlayerPos += QueuePos
		QueuePos = Vector2(0,0)
	if Moving:
		SwapFloat += 2.0*delta
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
