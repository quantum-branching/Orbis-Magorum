extends Label
func _process(_delta):
	text = " ".join(["HP:",int(Character.HP),"/",Character.HPMax])
