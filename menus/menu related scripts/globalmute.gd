extends Node
var isMuted : bool = false
var isFullscreen : bool = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		isFullscreen = !isFullscreen
		DisplayServer.window_set_mode((DisplayServer.WINDOW_MODE_FULLSCREEN if isFullscreen else DisplayServer.WINDOW_MODE_WINDOWED))
