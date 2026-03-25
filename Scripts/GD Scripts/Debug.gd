extends RichTextLabel
var Debug:Array[String] = []
var DisplayTimer:float = 0
var Display:bool = false

func _ready():
	DisplayTimer = fmod(Global.GlobalTime,1)
func _process(delta):
	visible = Display
	if Input.is_action_just_pressed("Debug"):
		Display = !Display
	DisplayTimer = DisplayTimer + delta
	if DisplayTimer > 1:
		DisplayTimer -= 1
		Debug = ["[font_size=12][outline_color=black][outline_size=4]FPS: ",str(int(Performance.get_monitor(Performance.TIME_FPS)))]
		Debug.append_array(["\nResolution: ",str(DisplayServer.screen_get_size().x),"x",str(DisplayServer.screen_get_size().y)])
		Debug.append_array(["\nPosition: ",str(int(Character.Pos.x)),",",str(int(Character.Pos.y))])
		Debug.append_array(["\nGlobal Time: ",str(int(Global.GlobalTime))])
		Debug.append("[/outline_size]")
		text = "".join(Debug)
