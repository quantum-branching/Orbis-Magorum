extends TextureButton
func _pressed():
	Global.resetsave()
	$"../Map Loading Speed".value = Global.MapLoadingSpeed
	$"../BrightnessSlider".value = Global.Brightness
	$"../CombatSpeedSetting".value = Global.CombatSpeed
