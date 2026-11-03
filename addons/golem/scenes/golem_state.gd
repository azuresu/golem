@tool
class_name GolemState extends State

## Format: [animation_library_name/]<animation_name>. Changing it in realtime has no effect.
@export var animation_name: String
## Animation is played backward. Changing it in realtime has no effect.
@export var play_backward: bool
@export var speed_scale:= 1.0

var animation_time: float

var golem: Golem:
	get: return machine.owner

func get_speed_scale() -> float:
	return speed_scale

func transition(state_name: StringName, params:= {}) -> void:
	super.transition(state_name, params)
	# Some states can be transitioned to itself when agent requires like melee and roll.
	if machine.current_state and machine.current_state.name == state_name:
		if machine.current_state.reset_when_transition_to_self:
			machine.play_animation(animation_name)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if machine:
		machine.set_animation_condition(name, _has_animation_condition())

func _is_animation_between(begin_time: float, end_time: float, margin:= 0.0) -> bool:
	return animation_time >= begin_time - margin and animation_time <= end_time + margin

func _has_animation_condition() -> bool:
	return machine.current_state == self

func _on_animation_finished() -> void:
	pass

func _is_agent_moving() -> bool:
	var a:= golem.agent
	return a and (a.is_acting(&"move") or a.is_acting(&"move_back") or a.is_acting(&"move_left") or a.is_acting(&"move_right"))
