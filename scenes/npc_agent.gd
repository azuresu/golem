extends Node3D

var npc: Human:
	get: return get_parent()

func _process(delta: float) -> void:
	if npc.position.y < -5:
		npc.queue_free()

func _on_look_at_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		npc.look_at_target(body)

func _on_look_at_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		npc.look_at_target(null)

func _on_complex_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		npc.use_simple_shape(false)

func _on_complex_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		npc.use_simple_shape(true)
