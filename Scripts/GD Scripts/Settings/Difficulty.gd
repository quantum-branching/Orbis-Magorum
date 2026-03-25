extends HSlider
var TempText:String = ""

func _ready():
	value = Global.DifficultySetting

func _process(_delta):
	if value == 0:
		TempText = "Novice"
	if value == 1:
		TempText = "Apprentice"
	if value == 2:
		TempText = "Journeyman"
	if value == 3:
		TempText = "Expert"
	if value == 4:
		TempText = "Master"
	if value == 5:
		TempText = "Impossible"
	$"../Difficulty".text = " ".join(["Difficulty:",TempText])
	Global.DifficultySetting = value
	Global.Difficulty = 1.0 + .5*pow(value*1.1/4.0,pow(value*1.1/4.0,value*1.1))
