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

var height_ratio: float:
	get: return height / height_baseline

var skeleton: Skeleton3D:
	get:
		if not skeleton:
			skeleton = _look_for_skeleton($Model)
		return skeleton

func _ready() -> void:
	if skeleton:
		animation_player.root_node = skeleton.get_path()
	elif not Engine.is_editor_hint():
		Glaze.log_error("No skeleton found in golem: %s", self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
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
