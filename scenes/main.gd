extends Node3D

var fps_text: String:
	get: return "FPS: %d" % Engine.get_frames_per_second()
