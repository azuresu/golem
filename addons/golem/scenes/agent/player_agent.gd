class_name PlayerAgent extends GolemAgent

const MOUSE_SENSITIVITY:= 0.075
const CAMERA_FOLLOW_SPEED:= 5.0

var _mouse_motion: Vector2

func get_target_to_move() -> Node3D:
	if is_move_back_pressed():
		return $CameraYaw/Backward
	if is_move_left_pressed():
		return $CameraYaw/Left
	if is_move_right_pressed():
		return $CameraYaw/Right
	return $CameraYaw/Forward

func is_acting(action_name: StringName) -> bool:
	if action_name == &"move" and is_move_pressed():
		return true
	if action_name == &"move_back" and is_move_back_pressed():
		return true
	if action_name == &"move_left" and is_move_left_pressed():
		return true
	if action_name == &"move_right" and is_move_right_pressed():
		return true
	return false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion += event.relative

func _process(delta: float) -> void:
	$CameraYaw.rotation_degrees.y -= _mouse_motion.x * MOUSE_SENSITIVITY
	$CameraYaw/Camera.rotation_degrees.x = clampf($CameraYaw/Camera.rotation_degrees.x - _mouse_motion.y * MOUSE_SENSITIVITY, -90, 90)
	_mouse_motion = Vector2.ZERO

	var head: Node3D = golem.get_node("Head")
	var head_txm:= head.get_global_transform_interpolated()
	$CameraYaw.global_position = $CameraYaw.global_position.lerp(head_txm.origin, 1.0 - exp(-CAMERA_FOLLOW_SPEED * delta))

func _on_tree_entered() -> void:
	$CameraYaw.global_rotation.y = golem.global_rotation.y

func is_move_pressed() -> bool:
	return Input.is_action_pressed("ui_up")

func is_move_back_pressed() -> bool:
	return Input.is_action_pressed("ui_down")

func is_move_left_pressed() -> bool:
	return Input.is_action_pressed("ui_left")

func is_move_right_pressed() -> bool:
	return Input.is_action_pressed("ui_right")
