@tool
class_name Golem extends CharacterBody3D

@export var skeleton: Skeleton3D

@onready var animation_state_machine: AnimationStateMachine = $AnimationStateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	if skeleton:
		animation_player.root_node = skeleton.get_path()
