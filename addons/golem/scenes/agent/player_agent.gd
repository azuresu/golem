class_name PlayerAgent extends GolemAgent

const MOUSE_SENSITIVITY:= 0.075
const CAMERA_FOLLOW_SPEED:= 5.0

var _mouse_motion: Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion += event.relative

func _process(delta: float) -> void:
	$CameraPivot.rotation_degrees.y -= _mouse_motion.x * MOUSE_SENSITIVITY
	$CameraPivot/Camera.rotation_degrees.x = clampf($CameraPivot/Camera.rotation_degrees.x - _mouse_motion.y * MOUSE_SENSITIVITY, -90, 90)
	_mouse_motion = Vector2.ZERO

	var head: Node3D = golem.get_node("Head")
	var head_txm:= head.get_global_transform_interpolated()
	$CameraPivot.global_position = $CameraPivot.global_position.lerp(head_txm.origin, 1.0 - exp(-CAMERA_FOLLOW_SPEED * delta))
