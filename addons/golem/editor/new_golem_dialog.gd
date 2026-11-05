@tool
extends Window

var _golem_type: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TypeList.select(0)
	_on_type_selected(0)
	close_requested.connect(hide)

func _on_create() -> void:
	var scene_name: String = %NameEdit.text
	%TypeList.item_selected
	if (_create_golem_scene()):
		await get_tree().process_frame
		var scene = EditorInterface.get_edited_scene_root()
		scene.name = scene_name
	else:
		printerr("No golem type is selected.")
	hide()

func _on_cancel() -> void:
	hide()

func _create_golem_scene() -> bool:
	match _golem_type:
		"Golem":
			EditorInterface.open_scene_from_path("res://addons/golem/scenes/golem.tscn", true)
			return true
		"Humanoid":
			EditorInterface.open_scene_from_path("res://addons/golem/scenes/humanoid.tscn", true)
			return true
	return false

func _on_type_selected(index: int) -> void:
	_golem_type = %TypeList.get_item_text(index)
