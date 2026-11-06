@icon("res://addons/golem/scenes/golem.png")
class_name Golem extends CharacterBody3D

const POSE_STAND:= &"stand"
const POSE_CROUCH:= &"crouch"

@export var action_state_machine: ActionStateMachine
@export var skeleton: Skeleton3D
@export var gaze_modifier: LookAtModifier3D
@export var gaze_point: Node3D
@export var profile: GolemProfile
@export var default_state: StringName
@export var animation_tree_node_gap:= Vector2i(200, 200)
@export var auto_build:= true

var pose:= POSE_STAND

# Use set_agent() in script.
var agent: GolemAgent

func set_agent(a: GolemAgent) -> void:
	if agent:
		agent.queue_free()
	agent = a
	if agent:
		agent.golem = self
		add_child(agent)

func turn_to(global_pos: Vector3, speed: float, delta: float) -> void:
	var r:= global_transform.looking_at(global_pos).basis.get_euler()
	if r.length_squared() > 0:
		var d:= absf(angle_difference(rotation.y, r.y))
		if d < speed * delta:
			rotation.y = r.y
		else:
			rotation.y = lerp_angle(rotation.y, r.y, minf(speed * delta, d) / d)

func move_to(global_pos: Vector3, speed: float) -> void:
	if speed > 0:
		var r:= global_transform.looking_at(global_pos).basis.get_euler()
		velocity = Vector3(-sin(r.y) * speed, velocity.y, -cos(r.y) * speed)
	else:
		velocity = Vector3(0, velocity.y, 0)

func gaze_at(target: Node3D) -> void:
	if gaze_modifier:
		if target:
			if target is Golem and target.gaze_point:
				gaze_modifier.target_node = target.gaze_point.get_path()
			else:
				gaze_modifier.target_node = target.get_path()
		else:
			gaze_modifier.target_node = ""

func _ready() -> void:
	if default_state:
		action_state_machine.set_current_state(default_state)
	if skeleton:
		# Set in runtime to make sure root node is correct.
		$AnimationPlayer.root_node = skeleton.get_path()
		skeleton.skeleton_updated.connect(_on_skeleton_updated)
	# Set agent if it has been added into scene.
	for ch in get_children():
		if ch is GolemAgent:
			agent = ch
			agent.golem = self
			break

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_skeleton_updated() -> void:
	for ch in get_children():
		if ch is BoneShape:
			ch.update(skeleton)
