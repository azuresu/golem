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
		for i in skeleton.get_bone_count():
			if name == skeleton.get_bone_name(i):
				_bone = BoneAttachment3D.new()
				_bone.bone_idx = i
				skeleton.add_child(_bone)
			if end_bone and end_bone == skeleton.get_bone_name(i):
				_bone2 = BoneAttachment3D.new()
				_bone2.bone_idx = i
				skeleton.add_child(_bone2)
		if not _bone:
			Glaze.log_error("Bone: %s not found in golem: %s", name, golem)
		if end_bone and not _bone2:
			Glaze.log_error("End bone: %s not found in golem: %s", end_bone, golem)

# Make sure to use Jolt engine otherwise rotation/scale won't work.
func _physics_process(delta: float) -> void:
	if disabled:
		return

	if not _height_ratio == golem.height_ratio:
		_height_ratio = golem.height_ratio
		shape.radius = diameter * 0.5 * _height_ratio
		shape.height = length * _height_ratio

	if _bone:
		if _bone2:
			global_position = lerp(_bone.global_position, _bone2.global_position, 0.5)
			if not global_position == _bone2.global_position:
				look_at(_bone2.global_position)
			rotate_object_local(Vector3.LEFT, PI * 0.5)
		else:
			global_position = _bone.global_position
			global_rotation = _bone.global_rotation
