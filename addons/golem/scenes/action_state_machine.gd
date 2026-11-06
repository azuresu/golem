class_name ActionStateMachine extends StateMachine

@export var animation_tree: AnimationTree
@export var animation_library_default: String
@export var default_xfade_time:= 0.2

var playback: AnimationNodeStateMachinePlayback:
	get: return animation_tree.get("parameters/StateMachine/playback")

# Cache conditions to improve performance (a lot!)
var _animation_conditions: Dictionary[String, bool]
var _animation_time_scale:= 1.0

func get_states() -> Array[ActionState]:
	var r: Array[ActionState]
	r.assign(get_children().filter(func(ch): return ch is ActionState))
	return r

func set_animation_condition(param_name: String, param_value: bool) -> void:
	if not param_name in _animation_conditions or not _animation_conditions[param_name] == param_value:
		_animation_conditions[param_name] = param_value
		animation_tree.set("parameters/StateMachine/conditions/%s" % param_name, param_value)

func play_animation(animation_name: String) -> void:
	playback.start(animation_name)

func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		return
	state_entered.connect(_on_state_entered)
	state_exited.connect(_on_state_exited)
	animation_tree.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	super._process(delta)
	if current_state is ActionState:
		var anim_ss: float = current_state.get_speed_scale()
		current_state.animation_time += delta * anim_ss
		_set_animation_time_scale(anim_ss)

func _on_animation_finished(animation_name: String) -> void:
	if current_state is ActionState:
		current_state._on_animation_finished()

func _on_state_entered(state: State) -> void:
	if state is ActionState:
		state.animation_time = 0
		_set_animation_time_scale(state.get_speed_scale())

func _on_state_exited(state: State) -> void:
	if state is ActionState:
		_set_animation_time_scale(1.0)

func _set_animation_time_scale(time_scale: float) -> void:
	if not _animation_time_scale == time_scale:
		_animation_time_scale = time_scale
		animation_tree.set("parameters/TimeScale/scale", time_scale)
