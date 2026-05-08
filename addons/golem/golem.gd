@tool
class_name Golem extends CharacterBody3D

@export var skeleton: Skeleton3D

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

func _ready() -> void:
	if skeleton:
		animation_player.root_node = skeleton.get_path()
	else:
		if not Engine.is_editor_hint():
			Glaze.log_error("No skeleton found in golem: %s", self)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
