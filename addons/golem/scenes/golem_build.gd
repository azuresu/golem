@tool
extends Node

@export_tool_button("Build") var built_button:= _build

var golem: Golem:
	get: return owner

var _snapshot: Dictionary

func _process(delta: float) -> void:
	if Engine.is_editor_hint() and golem and golem.auto_build:
		var snapshot:= _get_snapshot()
		if not _snapshot == snapshot:
			_build()

func _get_snapshot() -> Dictionary:
	var snapshot:= {}
	if golem:
		if golem.default_state:
			snapshot["default_state"] = golem.default_state
		var gsm: GolemStateMachine = golem.get_node("StateMachine")
		for ch in gsm.get_children():
			if ch is GolemState:
				snapshot["state_%s" % ch.name] = 1
		snapshot["animation_tree_node_gap_x"] = golem.animation_tree_node_gap.x
		snapshot["animation_tree_node_gap_y"] = golem.animation_tree_node_gap.y
	return snapshot

func _build() -> void:
	_snapshot = _get_snapshot()
	Glaze.log_info("Building golem: %s...", golem)
	_build_animation_tree()
	Glaze.log_info("Building golem: %s completed", golem)

func _build_animation_tree() -> void:
	Glaze.log_info("Building animation tree....")
	var animation_tree: AnimationTree = golem.get_node("StateMachine").animation_tree
	var gap:= golem.animation_tree_node_gap
	if animation_tree:
		var blend_tree:= AnimationNodeBlendTree.new()
		var state_machine:= AnimationNodeStateMachine.new()
		var time_scale:= AnimationNodeTimeScale.new()
		blend_tree.add_node("StateMachine", state_machine)
		blend_tree.add_node("TimeScale", time_scale)
		blend_tree.set_node_position("StateMachine", Vector2(-2 * gap.x, 0))
		blend_tree.set_node_position("TimeScale", Vector2(-0.5 * gap.x, 0))
		blend_tree.connect_node("TimeScale", 0, "StateMachine")
		blend_tree.connect_node("output", 0, "TimeScale")
		var ap = animation_tree.get_node(animation_tree.anim_player)
		if ap is AnimationPlayer:
			_build_animations(state_machine, ap)
			_build_transitions(state_machine)
			Glaze.log_info("Building animation tree completed")
		else:
			Glaze.log_error("Animation player not found in animation tree: %s", animation_tree)
		animation_tree.tree_root = blend_tree
		animation_tree.get("parameters/StateMachine/playback").start(&"Start")
	else:
		Glaze.log_error("No animation tree set to golem state machine")

func _build_animations(sm: AnimationNodeStateMachine, ap: AnimationPlayer) -> void:
	Glaze.log_info("Building animation nodes...")
	var gap:= golem.animation_tree_node_gap
	var states: Dictionary[StringName, GolemState]
	for ch in golem.get_node("StateMachine").get_children():
		if ch is GolemState:
			states[ch.name] = ch
	var cols:= maxi(1, int(sqrt(states.size())))
	var pos: Vector2i
	for state_name in states:
		Glaze.log_debug("Building animation node: %s", state_name)
		if state_name == &"Start" or state_name == &"End":
			Glaze.log_error("Animation state name is not allowed: %s", state_name)
			continue
		var s = states[state_name]
		if s is GolemState and not sm.has_node(state_name):
			var ana:= AnimationNodeAnimation.new()
			var anim_name: String = s.animation_name
			if not anim_name:
				anim_name = s.name
			var anim_lib:= ""
			var i = anim_name.find("/")
			if i >= 0:
				anim_lib = anim_name.substr(0, i)
				anim_name = anim_name.substr(i + 1)
			if anim_lib:
				if ap.has_animation_library(anim_lib):
					var lib:= ap.get_animation_library(anim_lib)
					if not lib.has_animation(anim_name):
						Glaze.log_error("Animation: %s not found in animation library %s used by state: %s", anim_name, anim_lib, state_name)
				else:
					Glaze.log_error("Animation library: %s not found used by state: %s", anim_lib, state_name)
			else:
				if not ap.has_animation(anim_name):
					printerr("Animation %s not found used by state: %s" % [anim_name, state_name])
			ana.animation = ("%s/%s" % [anim_lib, anim_name]) if anim_lib else anim_name
			ana.play_mode = AnimationNodeAnimation.PLAY_MODE_BACKWARD if s.play_backward else AnimationNodeAnimation.PLAY_MODE_FORWARD
			sm.add_node(state_name, ana)
			sm.set_node_position(state_name, gap * pos)
			pos.x += 1
			if pos.x >= cols:
				pos.x = 0
				pos.y += 1
	if not golem.default_state and states:
		golem.default_state = states.keys()[0]

func _build_transitions(sm: AnimationNodeStateMachine) -> void:
	Glaze.log_info("Building animation transitions...")
	var node_list: Array[StringName] = sm.get_node_list()
	for i in node_list.size():
		if sm.get_node(node_list[i]) is AnimationNodeAnimation:
			if node_list[i] == &"Start" or node_list[i] == &"End":
				continue
			for j in node_list.size():
				if i == j or node_list[j] == &"Start" or node_list[j] == &"End":
					continue
				Glaze.log_debug("Building transition from %s to %s", node_list[i], node_list[j])
				var trans:= AnimationNodeStateMachineTransition.new()
				trans.xfade_time = 0.2 # Maybe this should be configurable in animation state.
				trans.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
				trans.advance_condition = str(node_list[j])
				sm.add_transition(node_list[i], node_list[j], trans)
	if golem.default_state:
		Glaze.log_debug("Building default transition from Start to %s", golem.default_state)
		var trans:= AnimationNodeStateMachineTransition.new()
		trans.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
		sm.add_transition(&"Start", golem.default_state, trans)

func _has_transition(sm: AnimationNodeStateMachine, from: StringName, to: StringName) -> bool:
	for i in sm.get_transition_count():
		if sm.get_transition_from(i) == from and sm.get_transition_to(i) == to:
			return true
	return false
