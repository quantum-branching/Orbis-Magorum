extends TextureProgressBar
func _process(_delta):
	value = 100*Character.Mana/Character.ManaMax
