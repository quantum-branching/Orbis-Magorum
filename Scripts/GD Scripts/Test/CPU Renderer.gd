extends Sprite2D
var TextureImage:Image
@export var MapTexture:Texture
var MapY:int
var MapColor:Color
##The value of [method Global.Renderer] last frame, this is used to prevent repeating certain code every frame that only needs to be ran once. Uses [method Global.RendererEnums].
var Renderer:int = -1

var MapImage:Image
var WaterImage:Image
var SandImage:Image
var GrassImage:Image
var StoneImage:Image

func _ready():
	TextureImage = Image.create_empty(7616,7616,false,Image.FORMAT_RGB8)
	if FileAccess.file_exists("user://map.webp"):
		TextureImage.load("user://map.webp")
		texture = ImageTexture.create_from_image(TextureImage)
		MapY = 477
	MapImage = MapTexture.get_image()
	WaterImage = load("res://Images/Maps/Water.webp").get_image()
	SandImage = load("res://Images/Maps/Sand.webp").get_image()
	GrassImage = load("res://Images/Maps/Grass.webp").get_image()
	StoneImage = load("res://Images/Maps/Stone.webp").get_image()

func _process(_delta):
	if Global.Renderer == 0:
		if MapY < 476:
			RenderLine(MapY)
			MapY += 1
			$"../Time Left".text = "".join([str(int(10.0*(476 - MapY)/Performance.get_monitor(Performance.TIME_FPS))/10.0),"s Left"])
		if MapY == 476:
			texture = ImageTexture.create_from_image(TextureImage)
			TextureImage.save_webp("user://map.webp")
			MapY += 1
			$"../Time Left".visible = false
		position = -16*Vector2i($"../Player".PlayerPos)+Vector2i(16,16)
		if Renderer != 0:
			$"../GPU Renderer".visible = false
			visible = true
			if MapY < 476:
				$"../Time Left".visible = true
			Renderer = 0
	elif Global.Renderer == 1:
		if Renderer != 1:
			$"../GPU Renderer".visible = true
			visible = false
			$"../Time Left".visible = false
			Renderer = 1

func RenderLine(y):
	for x in 476:
		for x1 in 16:
			for y1 in 16:
				if MapImage.get_pixel(x,y).g > .75:
					MapColor = StoneImage.get_pixel(x1,y1)
				elif MapImage.get_pixel(x,y).g > .5:
					MapColor = GrassImage.get_pixel(x1,y1)
				elif MapImage.get_pixel(x,y).g > .25:
					MapColor = SandImage.get_pixel(x1,y1)
				elif MapImage.get_pixel(x,y).g < .25:
					MapColor = WaterImage.get_pixel(x1,y1)
				TextureImage.set_pixel(16*x+x1,16*y+y1,MapColor)
