@tool
class_name GolemTool extends Node

@export var state_machine: GolemStateMachine
@export var default_state: StringName
@export var editor_node_gap:= Vector2i(200, 200)
@export_tool_button("Build Animation Tree") var build_animation_tree:= _build_animation_tree

func _build_animation_tree() -> void:
	print("Building animation tree...")
	var animation_tree:= state_machine.animation_tree
	if animation_tree:
		var blend_tree:= AnimationNodeBlendTree.new()
		var state_machine:= AnimationNodeStateMachine.new()
		var time_scale:= AnimationNodeTimeScale.new()
		blend_tree.add_node("StateMachine", state_machine)
		blend_tree.add_node("TimeScale", time_scale)
		blend_tree.set_node_position("StateMachine", Vector2(-2 * editor_node_gap.x, 0))
		blend_tree.set_node_position("TimeScale", Vector2(-0.5 * editor_node_gap.x, 0))
		blend_tree.connect_node("TimeScale", 0, "StateMachine")
		blend_tree.connect_node("output", 0, "TimeScale")
		var ap = animation_tree.get_node(animation_tree.anim_player)
		if ap is AnimationPlayer:
			_build_animations(state_machine, ap)
			_build_transitions(state_machine)
			print("Building animation tree completed.")
		else:
			printerr("Animation player not found in animation tree: %s" % animation_tree)
		animation_tree.tree_root = blend_tree
	else:
		printerr("No animation tree set for animation state machine: %s", self)

func _build_animations(sm: AnimationNodeStateMachine, ap: AnimationPlayer) -> void:
	print("Building animation nodes...")
	var states: Dictionary[StringName, GolemState]
	for ch in state_machine.get_children():
		if ch is GolemState:
			states[ch.name] = ch
	var cols:= maxi(1, int(sqrt(states.size())))
	var pos: Vector2i
	for state_name in states:
		print("Building animation node: %s" % state_name)
		if state_name == &"Start" or state_name == &"End":
			printerr("Animation state name is not allowed: %s" % state_name)
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
						printerr("Animation: %s not found in animation library %s used by state: %s" % [anim_name, anim_lib, state_name])
				else:
					printerr("Animation library: %s not found used by state: %s" % [anim_lib, state_name])
			else:
				if not ap.has_animation(anim_name):
					printerr("Animation %s not found used by state: %s" % [anim_name, state_name])
			ana.animation = ("%s/%s" % [anim_lib, anim_name]) if anim_lib else anim_name
			ana.play_mode = AnimationNodeAnimation.PLAY_MODE_BACKWARD if s.play_backward else AnimationNodeAnimation.PLAY_MODE_FORWARD
			sm.add_node(state_name, ana)
			sm.set_node_position(state_name, editor_node_gap * pos)
			pos.x += 1
			if pos.x >= cols:
				pos.x = 0
				pos.y += 1
	if not default_state and states:
		default_state = states.keys()[0]
	print("Default state: %s" % default_state)

func _build_transitions(sm: AnimationNodeStateMachine) -> void:
	print("Building animation transitions...")
	var node_list: Array[StringName] = sm.get_node_list()
	for i in node_list.size():
		if sm.get_node(node_list[i]) is AnimationNodeAnimation:
			if node_list[i] == &"Start" or node_list[i] == &"End":
				continue
			for j in node_list.size():
				if i == j or node_list[j] == &"Start" or node_list[j] == &"End":
					continue
				var trans:= AnimationNodeStateMachineTransition.new()
				trans.xfade_time = 0.2 # Maybe this should be configurable in animation state.
				trans.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
				trans.advance_condition = str(node_list[j])
				sm.add_transition(node_list[i], node_list[j], trans)
				print("Build transition from %s to %s" % [node_list[i], node_list[j]])
	if default_state:
		var trans:= AnimationNodeStateMachineTransition.new()
		trans.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
		sm.add_transition(&"Start", default_state, trans)
		print("Build transition from Start to default: %s" % default_state)

func _has_transition(sm: AnimationNodeStateMachine, from: StringName, to: StringName) -> bool:
	for i in sm.get_transition_count():
		if sm.get_transition_from(i) == from and sm.get_transition_to(i) == to:
			return true
	return false
