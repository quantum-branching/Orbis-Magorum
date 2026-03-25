extends TextureButton

var shader:ShaderMaterial
var texture:Texture

func _ready():
	shader = ShaderMaterial.new()
	shader.shader = load("res://Shaders/Main Menu/MenuBackground.gdshader")
	texture = shader.shader.get_default_texture_parameter("Noise1")

func _pressed():
	if Global.NewCharacterMod:
		if len(Global.ClassNo) > 0:
			get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/Characters.tscn")
		else:
			get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/CreateCharacter.tscn")
	else:
		get_tree().change_scene_to_file("res://Scripts/GD Scripts/Select Character/LegacyCharacters.tscn")

func _process(_delta):
	if is_hovered():
		shader.shader = load("res://Shaders/Main Menu/MenuFireShader.gdshader")
		shader.shader.set_default_texture_parameter("Noise1",load("res://Shaders/Main Menu/Noise.tres"))
		material = shader
	else:
		shader.shader = load("res://Shaders/Main Menu/MenuBackground.gdshader")
		shader.shader.set_default_texture_parameter("Noise1",texture)
