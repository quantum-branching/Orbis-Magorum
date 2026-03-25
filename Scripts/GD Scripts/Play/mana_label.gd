extends Label
func _process(_delta):
	text = " ".join(["Mana:",int(Character.Mana),"/",Character.ManaMax])
