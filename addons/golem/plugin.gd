@tool
extends EditorPlugin

const MENU_ITEM_CREATE_NEW_GOLEM:= "Create New Golem..."

var new_golem_dialog: Window

func _enable_plugin() -> void:
	print("Plugin Golem is enabled.")
	print("You can create new Golem scene in menu Tools.")

func _disable_plugin() -> void:
	print("Plugin Golem is disabled.")

func _enter_tree() -> void:
	add_tool_menu_item(MENU_ITEM_CREATE_NEW_GOLEM, _on_create_new_humanoid)
	new_golem_dialog = preload("res://addons/golem/scenes/editor/new_golem_dialog.tscn").instantiate()
	EditorInterface.get_editor_main_screen().add_child(new_golem_dialog)

func _exit_tree() -> void:
	remove_tool_menu_item(MENU_ITEM_CREATE_NEW_GOLEM)
	new_golem_dialog.queue_free()
	new_golem_dialog = null

func _on_create_new_humanoid() -> void:
	new_golem_dialog.show()
