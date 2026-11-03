@tool
class_name Golem extends CharacterBody3D

@export var skeleton: Skeleton3D

@onready var state_machine: GolemStateMachine = $StateMachine

var agent: GolemAgent:
	set(a):
		if agent:
			agent.queue_free()
		agent = a
		if agent:
			agent.golem = self
			add_child(agent)

var _default_state:= &"Start"

func turn_to(global_pos: Vector3, speed: float, delta: float) -> void:
	var r:= global_transform.looking_at(global_pos).basis.get_euler()
	if r.length_squared() > 0:
		var d:= absf(angle_difference(rotation.y, r.y))
		if d < speed * delta:
			rotation.y = r.y
		else:
			rotation.y = lerp_angle(rotation.y, r.y, minf(speed * delta, d) / d)

func move_to(global_pos: Vector3, speed: float) -> void:
	var r:= global_transform.looking_at(global_pos).basis.get_euler()
	velocity = Vector3(-sin(r.y) * speed, velocity.y, -cos(r.y) * speed)

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if _default_state and state_machine:
		state_machine.set_current_state(_default_state)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	if state_machine:
		var states: Array[StringName]
		states.append(&"Start")
		for s in state_machine.get_states():
			states.append(s.name)
		properties.append({
			"name": "default_animation",
			"type": TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(states)
		})
	return properties

func _get(property: StringName) -> Variant:
	if property == "default_animation":
		return _default_state
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == "default_animation" and value is StringName:
		_default_state = value
		if Engine.is_editor_hint() and state_machine:
			state_machine.play_animation(value)
		return true
	return false
