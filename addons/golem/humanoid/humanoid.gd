@tool
class_name Humanoid extends Golem

@export var look_at_enabled:= true:
	set(e):
		look_at_enabled = e
		_update_look_at.call_deferred()

@export var look_at_target: Node3D:
	set(target):
		look_at_target = Glaze.validate(target)
		_update_look_at.call_deferred()

var look_at_modifier: LookAtModifier3D:
	get: return Glaze.validate(look_at_modifier)

func _update_look_at() -> void:
	if look_at_enabled:
		if not look_at_modifier:
			if skeleton:
				look_at_modifier = Glaze.new_scene("res://addons/golem/humanoid/humanoid_look_at.tscn", skeleton)
			else:
				Glaze.log_warn("Look at modifier cannot be added as no skeleton found in %s", self)
	else:
		if look_at_modifier:
			look_at_modifier.free()
			look_at_modifier = null

	if look_at_modifier:
		if look_at_target:
			var target:= look_at_target.get_path()
			if look_at_target is Golem and look_at_target.has_node("Head"):
				target = look_at_target.get_node("Head").get_path()
			look_at_modifier.target_node = target
		else:
			look_at_modifier.target_node = ""
