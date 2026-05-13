class_name Golem extends CharacterBody3D

@onready var animation_state_machine: AnimationStateMachine = $AnimationStateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var marker: Node3D = $Marker

@export var height:= 1.0:
	set(h):
		if h > 0:
			height = h

@export var height_baseline:= 1.0:
	set(h):
		if h > 0:
			height_baseline = h

var height_ratio: float:
	get: return height / height_baseline

var skeleton: Skeleton3D:
	get:
		if not skeleton:
			skeleton = _find_skeleton(self)
			if not skeleton:
				Glaze.log_error("Skeleton not found in golem: %s", self)
		return skeleton

func get_forward_vector() -> Vector3:
	return $Forward.global_position - global_position

func _ready() -> void:
	marker.visible = false
	if skeleton:
		animation_player.root_node = skeleton.get_path()

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()

func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for ch in node.get_children():
		var s:= _find_skeleton(ch)
		if s:
			return s
	return null
