@tool
class_name Golem extends CharacterBody3D

@export var skeleton: Skeleton3D

@onready var _asm: AnimationStateMachine = $AnimationStateMachine

var _default_animation: StringName

func set_animation_state(state_name: String, params:= {}) -> void:
	if _asm:
		_asm.set_current_state(state_name, params)

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if _default_animation and _asm:
		_asm.set_current_state(_default_animation)

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	if _asm:
		var states: Array[StringName]
		for s in _asm.get_animation_states():
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
		if not _default_animation and _asm:
			for s in _asm.get_animation_states():
				_default_animation = s.name
				break
		return _default_animation
	return null

func _set(property: StringName, value: Variant) -> bool:
	if property == "default_animation":
		_default_animation = value
		if Engine.is_editor_hint() and _asm:
			_asm.play_animation(value)
		return true
	return false
