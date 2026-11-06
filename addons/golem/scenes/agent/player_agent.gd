class_name PlayerAgent extends GolemAgent

const MOUSE_SENSITIVITY:= 0.075
const CAMERA_FOLLOW_SPEED:= 10.0

var _mouse_motion: Vector2
var _gazed_target: Node3D

func target_to_move() -> Node3D:
	if Input.is_action_pressed("run"):
		if Input.is_action_pressed("move_forward"):
			return $CameraPivot/Forward
	if Input.is_action_pressed("move_backward"):
		return $CameraPivot/Backward
	if Input.is_action_pressed("move_left"):
		return $CameraPivot/Left
	if Input.is_action_pressed("move_right"):
		return $CameraPivot/Right
	return $CameraPivot/Forward

func state_to_act() -> StringName:
	if Input.is_action_pressed("jump"):
		return &"roll" if golem.pose == Golem.POSE_CROUCH else &"jump_up"
	if Input.is_action_pressed("run"):
		if Input.is_action_pressed("move_forward"):
			return &"run"
	if Input.is_action_pressed("move_forward") or \
	Input.is_action_pressed("move_backward") or \
	Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right"):
		return &"walk" if golem.pose == Golem.POSE_STAND else &"crouch_walk"
	return &"stand" if golem.pose == Golem.POSE_STAND else &"crouch"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion += event.relative

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("crouch"):
		golem.pose = Golem.POSE_CROUCH if golem.pose == Golem.POSE_STAND else Golem.POSE_STAND

func _ready() -> void:
	$CameraPivot.global_rotation.y = golem.global_rotation.y
	$CameraPivot/Arm.add_excluded_object(golem)

func _process(delta: float) -> void:
	var pivot: Node3D = $CameraPivot
	pivot.rotation_degrees.y -= _mouse_motion.x * MOUSE_SENSITIVITY
	pivot.rotation_degrees.x = clampf(pivot.rotation_degrees.x - _mouse_motion.y * MOUSE_SENSITIVITY, -90, 90)
	_mouse_motion = Vector2.ZERO

	var head: Node3D = golem.get_node("Head")
	if head:
		var head_pos:= head.get_global_transform_interpolated().origin
		pivot.global_position = pivot.global_position.lerp(head_pos, 1.0 - exp(-CAMERA_FOLLOW_SPEED * delta))

func _on_tree_exiting() -> void:
	$CameraPivot/Arm.remove_excluded_object(golem)

func _on_gaze_area_body_entered(body: Node3D) -> void:
	if _can_gaze(body):
		golem.gaze_at(body)
		_gazed_target = body

func _on_gaze_area_body_exited(body: Node3D) -> void:
	if body == _gazed_target:
		golem.gaze_at(null)
		_gazed_target = null

func _can_gaze(target: Node3D) -> bool:
	return target is Golem and not target == golem and not _gazed_target
