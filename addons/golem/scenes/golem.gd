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

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if _default_state and state_machine:
		state_machine.set_current_state(_default_state)

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
		if not _default_state and state_machine:
			for s in state_machine.get_states():
				_default_state = s.name
				break
		return _default_state
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == "default_animation" and value is StringName:
		_default_state = value
		if Engine.is_editor_hint() and state_machine:
			state_machine.play_animation(value)
		return true
	return false
