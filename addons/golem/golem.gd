@tool
class_name Golem extends CharacterBody3D

@export var skeleton: Skeleton3D

@onready var animation_state_machine: AnimationStateMachine = $AnimationStateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

func set_default_shapes_disabled(disabled: bool) -> void:
	for ch in get_children():
		if ch is CollisionShape3D and "default_shape" in ch and ch.default_shape:
			ch.disabled = disabled

func _ready() -> void:
	if skeleton:
		animation_player.root_node = skeleton.get_path()
	else:
		if not Engine.is_editor_hint():
			Glaze.log_error("No skeleton found in golem: %s", self)
