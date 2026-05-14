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

func set_animation(state_name: String, params:= {}) -> void:
	animation_state_machine.set_current_state(state_name, params)

func get_front_vector() -> Vector3:
	return $Front.global_position - global_position

func turn_front(global_pos: Vector3, turn_speed: float, delta: float) -> void:
	var r:= global_transform.looking_at(global_pos).basis.get_euler()
	if r.length_squared() > 0:
		var d:= absf(angle_difference(rotation.y, r.y))
		rotation.y = lerp_angle(rotation.y, r.y, minf(turn_speed * delta, d) / d)

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
