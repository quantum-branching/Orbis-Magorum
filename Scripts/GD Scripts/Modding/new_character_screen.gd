extends TextureButton

func _ready():
	if Global.NewCharacterMod:
		button_pressed = true
func _toggled(toggled_on):
	if toggled_on:
		modulate = Color(0.65,0.75,0.65)
		Global.NewCharacterMod = true
	else:
		modulate = Color(1,0.9,0.9)
		Global.NewCharacterMod = false
