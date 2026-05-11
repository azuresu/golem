@tool
class_name Humanoid extends Golem

@export var look_at_target: Node3D:
	set(target):
		look_at_target = target
		_update_look_at.call_deferred()

var look_at_modifier

func _ready() -> void:
	super._ready()
	model_changed.connect(_on_model_changed)

func _on_model_changed() -> void:
	if look_at_modifier:
		look_at_modifier.free()
		look_at_modifier = null
	if skeleton:
		look_at_modifier = Glaze.new_scene("res://addons/golem/humanoid/humanoid_look_at.tscn", skeleton)
	_update_look_at()

func _update_look_at() -> void:
	if look_at_modifier:
		if look_at_target:
			var target_path:= look_at_target.get_path()
			if look_at_target is Golem and look_at_target.has_node("Head"):
				target_path = look_at_target.get_node("Head").get_path()
			look_at_modifier.target_node = target_path
		else:
			look_at_modifier.target_node = ""
