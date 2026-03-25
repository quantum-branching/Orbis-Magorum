extends TextureButton
var Error: = ""
var TempInt :int
func _pressed():
	if $"../Class List".Class == 0:
		Error = "Class"
	if $"../Race List".Race == 0:
		Error = "Race"
	if Error == "":
		Global.Names.append($"../Name".text)
		Global.ClassNo.append($"../Class List".Class)
		Global.RaceNo.append($"../Race List".Race)
		TempInt = Global.CallMaxHP($"../Class List".Class)
		Global.HP.append(TempInt)
		Global.HPMax.append(TempInt)
		TempInt = Global.CallMaxMana($"../Class List".Class)
		Global.Mana.append(TempInt)
		Global.ManaMax.append(TempInt)
		Global.Pos.append(Vector2(0,0))
		Global.Dead.append(false)
		$"../Saved Characters".LoadCharacters = true
func _process(_delta):
	Error = ""
	if $"../Name".text == "":
		Error = "Name"
	if $"../Class List".Class == 0:
		Error = "Class"
	if $"../Race List".Race == 0:
		Error = "Race"
	if Error:
		$".".disabled = true
	else:
		$".".disabled = false
