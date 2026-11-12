class_name PlayerAgent extends GolemAgent

const MOUSE_SENSITIVITY:= 0.075
const CAMERA_FOLLOW_SPEED:= 10.0

@export_category("Input Map Actions")
@export var ima_run:= "run"
@export var ima_move_forward:= "move_forward"
@export var ima_move_backward:= "move_backward"
@export var ima_move_left:= "move_left"
@export var ima_move_right:= "move_right"
@export var ima_jump:= "jump"
@export var ima_crouch:= "crouch"

var _mouse_motion: Vector2
var _gazed_target: Node3D

func target_to_move() -> Node3D:
	if _is_ima_pressed(ima_run):
		if _is_ima_pressed(ima_move_forward):
			return $CameraPivot/Forward
	if _is_ima_pressed(ima_move_backward):
		return $CameraPivot/Backward
	if _is_ima_pressed(ima_move_left):
		return $CameraPivot/Left
	if _is_ima_pressed(ima_move_right):
		return $CameraPivot/Right
	return $CameraPivot/Forward

func state_to_act() -> StringName:
	if _is_ima_pressed(ima_jump):
		if golem.pose == Golem.POSE_CROUCH:
			return &"crouch_roll"
		if _is_ima_pressed(ima_run) and _is_ima_pressed(ima_move_forward):
			return &"run_jump"
		return &"jump"
	if _is_ima_pressed(ima_run) and _is_ima_pressed(ima_move_forward):
		return &"run"
	if _is_ima_pressed(ima_move_forward) or _is_ima_pressed(ima_move_backward) or _is_ima_pressed(ima_move_left) or _is_ima_pressed(ima_move_right):
		return &"walk" if golem.pose == Golem.POSE_STAND else &"crouch_walk"
	return &"stand" if golem.pose == Golem.POSE_STAND else &"crouch"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_motion += event.relative

func _input(event: InputEvent) -> void:
	if _is_ima_pressed(ima_crouch, true):
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

func _is_ima_pressed(ima_name: String, just_pressed:= false) -> bool:
	if ima_name:
		if just_pressed:
			return Input.is_action_just_pressed(ima_name)
		return Input.is_action_pressed(ima_name)
	return false
