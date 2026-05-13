class_name Humanoid extends Golem

@onready var look_at_modifier: LookAtModifier3D = $LookAtModifier

func _ready() -> void:
	super._ready()
	if skeleton:
		look_at_modifier.reparent(skeleton)

func look_at_target(taret: Node3D) -> void:
	var target_path: NodePath
	if taret:
		target_path = taret.get_path()
	if taret is Golem and taret.has_node("Head"):
		target_path = taret.get_node("Head").get_path()
	look_at_modifier.target_node = target_path
