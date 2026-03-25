extends OptionButton
func _input(_event: InputEvent):
	if selected == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN,0)
	if selected == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED,0)
	if selected == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED,0)
