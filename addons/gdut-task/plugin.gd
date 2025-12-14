@tool
extends EditorPlugin

#-------------------------------------------------------------------------------

static func _add_setting(
	key: String,
	default_value: Variant,
	property_hint := PROPERTY_HINT_NONE,
	property_hint_string := "") -> void:

	if not ProjectSettings.has_setting(key):
		var property_info := {
			"name": key,
			"type": typeof(default_value),
			"hint": property_hint,
			"hint_string": property_hint_string,
		}

		ProjectSettings.set_setting(key, default_value)
		ProjectSettings.add_property_info(property_info)
		ProjectSettings.set_initial_value(key, default_value)
		ProjectSettings.set_as_basic(key, true)

static func _remove_setting(key: String) -> void:
	ProjectSettings.clear(key)

func _add_canonical() -> void:
	add_autoload_singleton("GDUT_TaskCanonical", "GDUT_TaskCanonical.gd")

func _remove_canonical() -> void:
	remove_autoload_singleton("GDUT_TaskCanonical")

func _print(message: String, plugin_name: Variant = null) -> void:
	if OS.has_feature("editor"):
		if plugin_name == null:
			plugin_name = _get_plugin_name()
		print_rich("🔌 [u]", plugin_name, "[/u]: ", message)

func _get_plugin_name() -> String:
	return "GDUT Task"

func _enable_plugin() -> void:
	_add_canonical()

func _disable_plugin() -> void:
	_remove_canonical()

func _enter_tree() -> void:
	_add_setting("gdut/task/general/enable_strict_method_check", false, 0, "")
	_add_setting("gdut/task/general/enable_strict_signal_check", false, 0, "")
	_add_setting("gdut/task/monitor/enable", true, 0, "")
	_add_setting("gdut/task/monitor/max_recursion", 5, PROPERTY_HINT_RANGE, "1,100")
	_add_setting("gdut/task/monitor/force_finalize_when_addon_exit_tree", true, 0, "")
	_print("Activated.")

func _exit_tree() -> void:
	_remove_setting("gdut/task/general/enable_strict_method_check")
	_remove_setting("gdut/task/general/enable_strict_signal_check")
	_remove_setting("gdut/task/monitor/enable")
	_remove_setting("gdut/task/monitor/max_recursion")
	_remove_setting("gdut/task/monitor/force_finalize_when_addon_exit_tree")
