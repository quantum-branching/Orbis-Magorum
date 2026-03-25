extends TextureButton
var OverrideEscape:bool = false
func _ready():
	OverrideEscape = true
func _pressed():
	get_tree().change_scene_to_file("res://Scripts/GD Scripts/Menu Screen/Menu Screen.tscn")
func _process(_delta):
	if Input.is_action_just_pressed("Escape") and not OverrideEscape:
		get_tree().change_scene_to_file("res://Scripts/GD Scripts/Menu Screen/Menu Screen.tscn")
	OverrideEscape = false
