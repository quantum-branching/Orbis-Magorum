@icon("res://Images/Icons/BackgroundIcon.png")
extends Sprite2D
func _process(delta):
	position.x = fmod(position.x + -60 * delta - 600,1200) + 600
	#rint(position.x)
	$"../BackgroundBottom".position.x = fmod($"../BackgroundBottom".position.x + -240 * delta - 600,1200) + 600
	if position.x >= 0:
		$"../BackgroundTopLeft".position.x = position.x - 1200
	else:
		$"../BackgroundTopLeft".position.x = position.x + 1200
	if $"../BackgroundBottom".position.x >= 0:
		$"../BackgroundBottomLeft".position.x = $"../BackgroundBottom".position.x - 1200
	else:
		$"../BackgroundBottomLeft".position.x = $"../BackgroundBottom".position.x + 1200
