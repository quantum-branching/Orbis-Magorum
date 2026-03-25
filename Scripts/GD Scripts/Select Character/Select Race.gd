extends TextureButton
@export var Race:int
var SelectionTime:float = 0


func _pressed():
	$"../../Create Character".Race = Race

func _process(delta):
	if $"../../Create Character".Race == Race:
		SelectionTime += delta
		modulate = Color(1.0+sin(1.5*SelectionTime)**2,1.0+sin(1.5*SelectionTime)**2,1.0+sin(1.5*SelectionTime)**2)
	else:
		modulate = Color(max(modulate.r-.75*delta,1),max(modulate.r-2.25*delta,1),max(modulate.r-.75*delta,1))
		SelectionTime = 0
