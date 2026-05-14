extends Node3D

var fps_text: String:
	get: return "FPS: %d" % Engine.get_frames_per_second()

func _ready() -> void:

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	var rt = RemoteTransform3D.new()
	rt.update_rotation = false
	rt.remote_path = $PlayerCamera.get_path()
	$HumanMale.get_node("Head").add_child(rt)
	$PlayerCamera.global_rotation = $HumanMale.global_rotation
