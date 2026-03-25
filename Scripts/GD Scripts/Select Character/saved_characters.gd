extends OptionButton
var LoadCharacters
func _ready():
	LoadCharacters = true

func ClassIcon(Number:int) -> Resource:
	var path:String = "".join(["res://Images/UI/Class Icons/",Global.ClassFromNo(Number),".webp"])
	var image:Resource = load(path)
	return image

func _process(_delta):
	if LoadCharacters == true:
		clear()
		for x in Global.Names:
			add_item(x)
		var Tooltip = ""
		for x in range(len(Global.Names)):
			Tooltip = " ".join([Global.RaceFromNo(Global.RaceNo[x]),Global.ClassFromNo(Global.ClassNo[x])])
			set_item_icon(x,ClassIcon(Global.ClassNo[x]))
			set_item_tooltip(x,Tooltip)
		LoadCharacters = false
	if selected > -1:
		Character.OpenCharacter = selected + 1
		Character.CallInfo(Character.OpenCharacter)
