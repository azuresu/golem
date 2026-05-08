@tool
class_name Humanoid extends Golem

@export var look_at_target: Node3D:
	set(target):
		look_at_target = Glaze.validate(target)
		_update_look_at_modifier.call_deferred()

var look_at_modifier: LookAtModifier3D:
	get:
		if not look_at_modifier:
			if skeleton:
				for ch in skeleton.get_children():
					if ch is LookAtModifier3D and ch.bone_name == "Head":
						look_at_modifier = ch
				if not look_at_modifier:
					Glaze.log_warn("No LookAtModifier on head in humanoid: %s", self)
			else:
				Glaze.log_warn("No skeleton to look for LookAtModifier on head in humanoid: %s", self)
		return look_at_modifier

func _update_look_at_modifier() -> void:
	if look_at_modifier:
		var path:= look_at_target.get_path() if look_at_target else ""
		if look_at_target is Golem and look_at_target.has_node("Head"):
			path = look_at_target.get_node("Head").get_path()
		look_at_modifier.target_node = path
