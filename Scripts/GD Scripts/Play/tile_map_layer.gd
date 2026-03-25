##Generates terrain using [TileMapLayer] that the player can walk around in.
extends TileMapLayer
#region Initializing Variables
##This [NoiseTexture2D] determines the height of the terrain. This is also used to generate the terrain that the player walks on. [br][br][b]Example: [/b][codeblock]noise = noise_height_text.noise
##for x in range(-19,19):
##    for y in range (-12,12):
##        var noise_val = noise.get_noise_2d(pos.x+x,pos.y+y)[/codeblock]
@export var noise_height_text : NoiseTexture2D
##This [NoiseTexture2D] determines where an encounter may randomly happen. If a player walks into a region where this noise has a high enough value there is a 30% chance that the character will encounter a creature. [br][br][b]Example: [/b] [codeblock]noiseenc = encounter_noise.noise
##for x in range(-19,19):
##    for y in range (-12,12):
##        var enc_val = noiseenc.get_noise_2d(pos.x+x,pos.y+y)[/codeblock]
@export var encounter_noise : NoiseTexture2D
##This is the chance that a player may enter an encounter when walking in tall grass or any equivalent. [br][br][b]Example: [/b][codeblock]if enc_val >= encchance:
##    ID = ID + 4
##    if Vector2i.ZERO == Vector2i(x,y):
##        Character.InEncounter = true[/codeblock]
var encchance :float = 0.3
##This [Noise] is a version of the [NoiseTexture2D]  [code]noise_height_text[/code]  that determines the height of the terrain. This is also used to generate the terrain that the player walks on. [br][br][b]Example: [/b][codeblock]for x in range(-19,19):
##    for y in range (-12,12):
##        var noise_val = noise.get_noise_2d(pos.x+x,pos.y+y)[/codeblock]
var noise : Noise
##This [Noise] is a version of the [NoiseTexture2D]  [code]noise_height_text[/code]  that determines where an encounter may randomly happen. If a player walks into a region where this noise has a high enough value there is a 30% chance that the character will encounter a creature. [br][br][b]Example: [/b] [codeblock]noiseenc = encounter_noise.noise
##for x in range(-19,19):
##    for y in range (-12,12):
##        var enc_val = noiseenc.get_noise_2d(pos.x+x,pos.y+y)[/codeblock]
var noiseenc : Noise
##This is the timer used for animating water.
var AnimatedWaterTimer:float = 0
##This is the timer used to time terrain generation frames.
var GhostRenderTimer:float = 0
##This is the position offset to move [TileMapLayer] instead of regenerating the terrain saved on [TileMapLayer].
var GhostRenderedPosition:Vector2i = Vector2i(0,0)
var scale1:float = 10.0/9.0
#endregion

#region Defining Custom Functions
##This function generates terrain and places it into a [TileMapLayer]. This function also animates the water. [br][br][b]Note: [/b]Since this function animates the water, this function must be called 2.5 times per second. [br][br][b]Example: [/b][codeblock] func _process(delta):
##    generate(delta)[/codeblock]
func generate(delta):
	Character.InTall = false
	var pos = Vector2i(Character.Pos)
	var ID : int = 0
	var AnimatedTexturePosition = 0
	if AnimatedWaterTimer < .4:
		AnimatedWaterTimer = AnimatedWaterTimer + delta
	else:
		AnimatedWaterTimer = 0
	for x in range(-36/scale1-1,36/scale1+1):
		for y in range (-22/scale1-1,22/scale1+1):
			var noise_val = noise.get_noise_2d(pos[0]+x,pos[1]+y)
			var enc_val = noiseenc.get_noise_2d(pos[0]+x,pos[1]+y)
			AnimatedTexturePosition = 0
			if noise_val > 0.2:
				ID = 1
			elif noise_val > -0.0:
				ID = 2
			elif noise_val <= -0.0:
				ID = 3
				if AnimatedWaterTimer > .2:
					AnimatedTexturePosition = 1
			if enc_val >= encchance:
				ID = ID + 4
				if Vector2i(0,0) == Vector2i(x,y):
					Character.InTall = true
			$".".set_cell(Vector2i(x,y),ID,Vector2i(AnimatedTexturePosition,0),0)

#endregion

#region Run-Time/Built-in Functions
#Function that runs when the scene starts.
#This function only runs when the player enter the map.
func _ready():
	noise = noise_height_text.noise
	noiseenc = encounter_noise.noise

#Run-Time function
func _process(delta):
	GhostRenderTimer = GhostRenderTimer + delta
	position = 16*scale1*(GhostRenderedPosition-Vector2i(Character.Pos))
	if $".".get_cell_source_id(Vector2i(Character.Pos)-GhostRenderedPosition) == 3:
		Character.InWater = true
	else:
		Character.InWater = false
	if GhostRenderTimer > .1:
		generate(GhostRenderTimer)
		GhostRenderTimer = 0
		GhostRenderedPosition = Vector2i(Character.Pos)
		position = Vector2i(0,0)

#endregion
