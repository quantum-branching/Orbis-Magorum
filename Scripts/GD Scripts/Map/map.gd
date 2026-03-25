extends MeshInstance2D
#region Initializing Variables
##Determines how much the character is zoomed in by.
var zoom:float = 0

#endregion

#region Run-Time/Built-in Functions

func _input(event):
	if event.is_action("Zoom In"):
		zoom -= .05
		$"../Zoom".value = -zoom
	if event.is_action("Zoom Out"):
		zoom += .05
		$"../Zoom".value = -zoom


#Run-Time function
func _process(_delta):
	zoom = -$"../Zoom".value
	material.set_shader_parameter("Scale",10*(2**zoom))
#endregion
