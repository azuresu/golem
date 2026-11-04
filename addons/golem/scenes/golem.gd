@icon("res://addons/golem/scenes/golem.png")
class_name Golem extends CharacterBody3D

@export var skeleton: Skeleton3D
@export var default_state: StringName
@export var animation_tree_node_gap:= Vector2i(200, 200)
@export var auto_build:= true

@export_category("Specification")
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var walk_speed:= 1.3
@export_custom(PROPERTY_HINT_NONE, "suffix:deg/s") var walk_turn_speed:= 360.0
@export_custom(PROPERTY_HINT_NONE, "suffix:m/s") var run_speed:= 3.8
@export_custom(PROPERTY_HINT_NONE, "suffix:deg/s")  var run_turn_speed:= 180.0

@onready var state_machine: GolemStateMachine = $StateMachine

var agent: GolemAgent:
	set(a):
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

func _ready() -> void:
	if default_state:
		state_machine.set_current_state(default_state)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
