extends Node2D

func _ready():
	$CombatSpeedSetting.value = Global.CombatSpeed
	if Global.MapLoadingSpeed == 1:
		Global.MapLoadingSpeed = max(min(int(Performance.get_monitor(Performance.TIME_FPS)/175.0),50),1)
	$BrightnessSlider.value = 100.0*Global.Brightness
	$TerrainRenderer.selected = Global.Renderer

func _process(_delta):
	#Combat Speed Modifer
	Global.CombatSpeed = $CombatSpeedSetting.value
	#Brightness
	$Brightness.text = " ".join(["Brightness:",roundi($BrightnessSlider.value)])
	Global.Brightness = $BrightnessSlider.value*0.01
	RenderingServer.global_shader_parameter_set("MeanBrightness",Global.Brightness)
	#Terrain Renderer
	Global.Renderer = $TerrainRenderer.selected
