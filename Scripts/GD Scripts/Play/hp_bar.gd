extends TextureProgressBar
func _process(_delta):
	value = 100*Character.HP/Character.HPMax
	tint_progress = Color(min(2-value/50,1),min(value/50,1),0)
