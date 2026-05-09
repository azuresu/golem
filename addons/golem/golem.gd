@tool
class_name Golem extends CharacterBody3D

@onready var animation_state_machine: AnimationStateMachine = $AnimationStateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

@export var height:= 1.0:
	set(h):
		if h > 0 and not h == height:
			height = h

@export var height_baseline:= 1.0:
	set(h):
		if h > 0 and not h == height_baseline:
			height_baseline = h

## Add offset to position when game starts to avoid overlap with objects like floor when it is too close.
@export var initial_offset_in_game:= Vector3(0, 0.1, 0)

## Allow golem to be collidable in editor so it will not overlap with others when you move it in editor.
@export var collidable_in_editor:= true

var height_ratio: float:
	get: return height / height_baseline

var skeleton: Skeleton3D:
	get:
		if not skeleton:
			skeleton = _look_for_skeleton($Model)
		return skeleton

func get_model_vector() -> Vector3:
	return $Model/Marker/End.global_position - $Model/Marker.global_position

func _ready() -> void:
	if skeleton:
		animation_player.root_node = skeleton.get_path()
	else:
		Glaze.log_warn("No skeleton found in golem: %s", self)
	$Model/Marker.visible = Engine.is_editor_hint()
	if not Engine.is_editor_hint():
		position += initial_offset_in_game

func _process(delta: float) -> void:
	if not rotation == Vector3.ZERO:
		var r = rotation
		rotation = Vector3.ZERO
		$Model.rotation = r

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		if not collidable_in_editor:
			return
	else:
		velocity += get_gravity() * delta
	move_and_slide()

func _look_for_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for ch in node.get_children():
		var s:= _look_for_skeleton(ch)
		if s:
			return s
	return null

func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary]
	if Engine.is_editor_hint():
		props.append({
			"name": "model_rotation",
			"type": TYPE_VECTOR3,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "-180, 180, 0.1"
		})
		props.append({
			"name": "animation_playing",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(animation_state_machine.states.keys())
		})
	return props

func _get(property: StringName) -> Variant:
	if property == &"model_rotation":
		return $Model.rotation_degrees
	if property == &"animation_playing":
		return animation_state_machine.current_state.name if animation_state_machine.current_state else ""
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == &"model_rotation":
		_set_model_rotation.call_deferred(value)
		return true
	if property == &"animation_playing":
		_set_animation_playing.call_deferred(value)
		return true
	return false

func _set_model_rotation(model_rotation: Vector3) -> void:
	$Model.rotation_degrees = model_rotation

func _set_animation_playing(animation_playing: StringName) -> void:
	if animation_playing in animation_state_machine.states:
		animation_state_machine.set_current_state(animation_playing)

func _mark_start_point() -> void:
	pass
