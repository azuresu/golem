extends Node3D

var hud_info: String:
	get:
		var info:= ""
		info += "FPS: %d" % Engine.get_frames_per_second()
		return info

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var fullscreen:= DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if fullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN)
