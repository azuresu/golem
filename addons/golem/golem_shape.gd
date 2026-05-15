extends CollisionShape3D

@export var diameter:= 0.1:
	set(d):
		if d > 0:
			diameter = d

@export var length:= 0.1:
	set(l):
		if l > 0:
			length = l

@export var end_bone:= ""

var golem: Golem:
	get: return get_parent()

var _bone: BoneAttachment3D
var _bone2: BoneAttachment3D
var _height_ratio: float

func _ready() -> void:
	var skeleton: Skeleton3D = golem.skeleton
	if skeleton:
		_bone = _find_bone(skeleton, name)
		if _bone:
			skeleton.add_child(_bone)
		else:
			Glaze.log_error("Bone: %s not found in golem: %s", name, golem)
		if end_bone:
			_bone2 = _find_bone(skeleton, end_bone)
			if _bone2:
				skeleton.add_child(_bone2)
			else:
				Glaze.log_error("End bone: %s not found in golem: %s", end_bone, golem)

# Make sure to use Jolt engine otherwise rotation/scale won't work.
func _physics_process(delta: float) -> void:
	
	if not _height_ratio == golem.height_ratio:
		_height_ratio = golem.height_ratio
		shape.radius = diameter * 0.5 * _height_ratio
		shape.height = length * _height_ratio

	# Always do this even when shape is disabled otherwise weird issues will be reported by physics engine.
	if _bone:
		if _bone2:
			global_position = lerp(_bone.global_position, _bone2.global_position, 0.5)
			if not global_position.is_equal_approx(_bone2.global_position):
				look_at(_bone2.global_position)
			rotate_object_local(Vector3.LEFT, PI * 0.5)
		else:
			global_position = _bone.global_position
			global_rotation = _bone.global_rotation

func _find_bone(skeleton: Skeleton3D, bone_name: String) -> BoneAttachment3D:
	var bone_index:= -1
	for i in skeleton.get_bone_count():
		if bone_name == skeleton.get_bone_name(i):
			bone_index = i
			break
		elif skeleton.get_bone_name(i).containsn(bone_name):
			bone_index = i
	if bone_index >= 0:
		var bone = BoneAttachment3D.new()
		bone.bone_idx = bone_index
		return bone
	return null
