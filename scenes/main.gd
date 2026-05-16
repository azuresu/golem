extends Node3D

const NPC_NAMES:= ["human_male2", "human_male3", "human_female", "human_female2", "human_female3", "human_female4"]

var debug_text: String:
	get:
		var t:= ""
		t += "FPS: %d" % Engine.get_frames_per_second()
		t += "\nNPC: %d" % _npc_count
		return t

var _npc_count: int

func _ready() -> void:
	var rt = RemoteTransform3D.new()
	rt.update_rotation = false
	rt.remote_path = $PlayerControl.get_path()
	$Player.get_node("Head").add_child(rt)
	$PlayerControl.set_player($Player)

func _spawn_npc() -> void:
	var npc_name = Glaze.rand_option(NPC_NAMES)
	var npc: Human = Glaze.new_scene("res://scenes/%s.tscn" % npc_name, self, {
		"position": Vector3(randf_range(1, 5) * (1 if randf() < 0.5 else -1), 0, randf_range(-24, -20))
	})
	npc.rotation_degrees.y = 180
	npc.set_animation("walk")
	npc.use_simple_shape(true)
	npc.set_collision_layer_value(3, true)
	npc.tree_exited.connect(func(): _npc_count -= 1)
	Glaze.new_scene("res://scenes/npc_agent.tscn", npc)
	_npc_count += 1
