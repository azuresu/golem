@tool
class_name GolemShape extends CollisionShape3D

@export var offset_position: Vector3
@export_custom(PROPERTY_HINT_RANGE, "-360,360,0.1,or_less,or_greater,radians_as_degrees") var offset_rotation: Vector3

func update(ske: Skeleton3D) -> void:
	var idx:= -1
	for i in ske.get_bone_count():
		if name == ske.get_bone_name(i):
			idx = i
			break
	if idx >= 0:
		var bone_txm:= ske.global_transform * ske.get_bone_global_pose(idx)
		global_transform = Transform3D(Basis.from_euler(offset_rotation) * bone_txm.basis, bone_txm * offset_position)

func _process(delta: float) -> void:
	# Golem is not running in editor so we update here.
	if Engine.is_editor_hint():
		if "skeleton" in owner and owner.skeleton is Skeleton3D:
			update(owner.skeleton)
