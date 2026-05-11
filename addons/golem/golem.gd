@tool
class_name Golem extends CharacterBody3D

signal model_changed
signal size_changed

@onready var animation_state_machine: AnimationStateMachine = $AnimationStateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var marker: Node3D = $Marker

@export var model: Node3D:
	set(m):
		model = m
		_notify_model_changed.call_deferred()

@export var height:= 1.0:
	set(h):
		if h > 0 and not h == height:
			height = h
			size_changed.emit()

@export var height_baseline:= 1.0:
	set(h):
		if h > 0 and not h == height_baseline:
			height_baseline = h
			size_changed.emit()

## Allow golem to be collidable in editor so it will not overlap with others when you move it in editor.
@export var collidable_in_editor:= false

var height_ratio: float:
	get: return height / height_baseline

var skeleton: Skeleton3D

func _ready() -> void:
	marker.visible = Engine.is_editor_hint()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		if not collidable_in_editor:
			return
	else:
		velocity += get_gravity() * delta
	move_and_slide()

func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary]
	if animation_state_machine:
		props.append({
			"name": "animation_playing",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": (",".join(animation_state_machine.states.keys())) if animation_state_machine else ""
		})
	return props

func _get(property: StringName) -> Variant:
	if property == &"animation_playing":
		return animation_state_machine.current_state.name if animation_state_machine.current_state else ""
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == &"animation_playing":
		_notify_animation_playing.call_deferred(value)
		return true
	return false

func _notify_model_changed() -> void:
	if model:
		skeleton = _find_skeleton(model)
		if not skeleton:
			Glaze.log_warn("No skeleton found in model: %s", self)
	else:
		skeleton = null
	$AnimationPlayer.root_node = skeleton.get_path() if skeleton else ""
	model_changed.emit()

func _notify_animation_playing(animation_playing: StringName) -> void:
	if animation_playing in animation_state_machine.states:
		animation_state_machine.set_current_state(animation_playing)

func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for ch in node.get_children():
		var s:= _find_skeleton(ch)
		if s:
			return s
	return null
