@tool
class_name AnimationState extends State

@export var animation_name: String
@export var play_backward: bool
@export var speed_scale:= 1.0

@export var playing: bool:
	get: return machine and machine.current_state == self
	set(p):
		if machine:
			if p and not machine.current_state == self:
				machine.set_current_state(name)
			elif not p and machine.current_state == self and machine.states:
				machine.set_current_state(machine.states.values()[0].name)

var animation_time: float

var golem: Golem:
	get: return machine.golem

#var character_agent: CharacterAgent:
	#get: return character.character_agent

func get_speed_scale() -> float:
	return speed_scale

func is_play_backward() -> bool:
	return play_backward

func _process(delta: float) -> void:
	if machine:
		machine.set_animation_condition(name, _has_animation_condition())

func _transition(state_name: String, params:= {}) -> void:
	super._transition(state_name, params)
	# Some states can be transitioned to itself when agent requires like melee and roll.
	if machine.current_state and machine.current_state.name == state_name:
		if machine.current_state.reset_when_transition_to_self:
			machine.play_animation(animation_name)

func _is_animation_between(begin_time: float, end_time: float, margin:= 0.0) -> bool:
	return animation_time >= begin_time - margin and animation_time <= end_time + margin

func _has_animation_condition() -> bool:
	return machine.current_state == self

func _on_animation_finished() -> void:
	pass
