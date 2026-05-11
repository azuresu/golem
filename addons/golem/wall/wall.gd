@tool
extends Node3D

@export var default_material: Material

func _ready() -> void:
	if not Engine.is_editor_hint():
		for ch in get_children():
			if ch is CSGShape3D:
				var cs:= CollisionShape3D.new()
				cs.shape = ch.bake_collision_shape()
				cs.transform = ch.transform
				add_child(cs)

func _on_child_entered_tree(node: Node) -> void:
	if node is CSGShape3D:
		node.child_entered_tree.connect(_on_child_entered_tree)
		node.material = default_material
