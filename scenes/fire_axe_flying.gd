extends RigidBody3D

var lifetime: float
var lifetime_max: float

func throw(source_pos: Vector3, target_pos: Vector3, speed: float, lifetime_max: float) -> void:
	global_position = source_pos
	look_at(target_pos)
	linear_velocity = (target_pos - source_pos).normalized() * speed
	self.lifetime_max = lifetime_max

func _process(delta: float) -> void:
	lifetime += delta
	if lifetime > lifetime_max:
		queue_free()

func _physics_process(delta: float) -> void:
	if %HitCast.is_colliding():
		var body = %HitCast.get_collider()
		if body is Human:
			if not body.is_in_group("player"):
				Glaze.new_scene("res://scenes/blood_splash.tscn", get_tree().get_first_node_in_group("stage"),
					{ "position": %HitCast.get_collision_point() })
				body.queue_free()
		else:
			queue_free()
