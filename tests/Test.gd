@abstract
class_name Test

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

func wait_defer(repeat := 0) -> void:
	while 0 <= repeat:
		emit_signal.call_deferred(_deferred.get_name())
		await _deferred
		repeat -= 1

func wait_defer_process(repeat := 0) -> void:
	while 0 <= repeat:
		await _tree.process_frame
		repeat -= 1

func wait_defer_physics(repeat := 0) -> void:
	while 0 <= repeat:
		await _tree.process_frame
		repeat -= 1

func wait_delay(timeout: float) -> void:
	var timer := _tree.create_timer(timeout)
	await timer.timeout

func is_true(value: Variant, message := "") -> bool:
	var result := {
		"condition": typeof(value) == TYPE_BOOL and value,
		"message": "is_true(%s)" % [value] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	_case_assert_results.push_back(result)
	return result.condition

func is_false(value: Variant, message := "") -> bool:
	var result := {
		"condition": typeof(value) == TYPE_BOOL and not value,
		"message": "is_false(%s)" % [value] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	_case_assert_results.push_back(result)
	return result.condition

func is_null(value: Variant, message := "") -> bool:
	var result := {
		"condition": typeof(value) == TYPE_NIL,
		"message": "is_null(%s)" % [value] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	_case_assert_results.push_back(result)
	return result.condition

func is_not_null(value: Variant, message := "") -> bool:
	var result := {
		"condition": typeof(value) != TYPE_NIL,
		"message": "is_not_null(%s)" % [value] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	_case_assert_results.push_back(result)
	return result.condition

func is_instance_of_type(
	value: Variant,
	expected_type: Variant,
	message := "") -> bool:

	var result := {
		"condition": is_instance_of(value, expected_type),
		"message": "is_instance_of_type(%s, %s)" % [value, expected_type.get_global_name() if expected_type is Script else expected_type] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	_case_assert_results.push_back(result)
	return result.condition

func is_empty(value: Variant, message := "") -> bool:
	var result := {
		"condition": false,
		"message": "is_empty(%s)" % [value] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	match typeof(value):
		TYPE_STRING, \
		TYPE_STRING_NAME, \
		TYPE_ARRAY, \
		TYPE_PACKED_BYTE_ARRAY, \
		TYPE_PACKED_INT32_ARRAY, \
		TYPE_PACKED_INT64_ARRAY, \
		TYPE_PACKED_FLOAT32_ARRAY, \
		TYPE_PACKED_FLOAT64_ARRAY, \
		TYPE_PACKED_STRING_ARRAY, \
		TYPE_PACKED_VECTOR2_ARRAY, \
		TYPE_PACKED_VECTOR3_ARRAY, \
		TYPE_PACKED_COLOR_ARRAY, \
		TYPE_PACKED_VECTOR4_ARRAY:
			result.condition = value.is_empty()
	_case_assert_results.push_back(result)
	return result.condition

func is_not_empty(value: Variant, message := "") -> bool:
	var result := {
		"condition": false,
		"message": "is_not_empty(%s)" % [value] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	match typeof(value):
		TYPE_STRING, \
		TYPE_STRING_NAME, \
		TYPE_ARRAY, \
		TYPE_PACKED_BYTE_ARRAY, \
		TYPE_PACKED_INT32_ARRAY, \
		TYPE_PACKED_INT64_ARRAY, \
		TYPE_PACKED_FLOAT32_ARRAY, \
		TYPE_PACKED_FLOAT64_ARRAY, \
		TYPE_PACKED_STRING_ARRAY, \
		TYPE_PACKED_VECTOR2_ARRAY, \
		TYPE_PACKED_VECTOR3_ARRAY, \
		TYPE_PACKED_COLOR_ARRAY, \
		TYPE_PACKED_VECTOR4_ARRAY:
			result.condition = not value.is_empty()
	_case_assert_results.push_back(result)
	return result.condition

func are_equal(expected: Variant, value: Variant, message := "") -> bool:
	var result := {
		"condition": false,
		"message": "are_equal(%s, %s)" % [expected, value] if message.is_empty() else message,
		"stacktrace": Engine.capture_script_backtraces().front(),
		"stacktrace_offset": 1,
	}
	match typeof(expected):
		TYPE_NIL, \
		TYPE_BOOL, \
		TYPE_INT, \
		TYPE_STRING, \
		TYPE_STRING_NAME, \
		TYPE_VECTOR2I, \
		TYPE_VECTOR3I, \
		TYPE_VECTOR4I, \
		TYPE_RECT2I, \
		TYPE_NODE_PATH, \
		TYPE_RID, \
		TYPE_OBJECT, \
		TYPE_CALLABLE, \
		TYPE_SIGNAL:
			if typeof(value) == typeof(expected):
				result.condition = expected == value
		TYPE_FLOAT:
			if typeof(value) == typeof(expected):
				result.condition = is_equal_approx(expected, value)
		TYPE_VECTOR2, \
		TYPE_VECTOR3, \
		TYPE_VECTOR4, \
		TYPE_RECT2, \
		TYPE_PLANE, \
		TYPE_QUATERNION, \
		TYPE_AABB, \
		TYPE_BASIS, \
		TYPE_PROJECTION, \
		TYPE_COLOR, \
		TYPE_TRANSFORM2D, \
		TYPE_TRANSFORM3D:
			if typeof(value) == typeof(expected):
				result.condition = expected.is_equal_approx(value)
		TYPE_ARRAY:
			if typeof(value) == TYPE_ARRAY:
				if expected.size() == value.size():
					var equal := true
					for index: int in expected.size():
						if \
							typeof(expected[index]) != typeof(value[index]) or \
							expected[index] != value[index]:

							equal = false
							break
					result.condition = equal
	_case_assert_results.push_back(result)
	return result.condition

func set_params(case_method: Callable, ...case_params: Array) -> void:
	assert(case_method.get_object() == self)
	assert(not case_method.get_method() in _unrelated_method_names)

	_case_params.get_or_add(case_method.get_method(), case_params)

func unrelate(case_method: Callable) -> void:
	assert(case_method.get_object() == self)
	assert(not case_method.get_method() in _unrelated_method_names)

	var index := _case_method_names.find(case_method.get_method())
	if index != -1:
		_case_method_names.remove_at(index)

func wait() -> bool:
	const RULE_M1 := "[color=#CCC]╺[/color] "
	const RULE_T1 := "[color=#CCC]┍[/color] "
	const RULE_L1 := "[color=#CCC]│[/color] "
	const RULE_B1 := "[color=#CCC]└[/color] "
	const RULE_M2 := RULE_L1 + RULE_M1
	const RULE_T2 := RULE_L1 + RULE_T1
	const RULE_L2 := RULE_L1 + RULE_L1
	const RULE_B2 := RULE_L1 + RULE_B1
	const RULE_M3 := RULE_L2 + RULE_M1

	var logs: Array[String] = []
	var case_passed := 0
	var case_failed := 0

	for case_method_name: StringName in _case_method_names:
		if not has_method(case_method_name):
			logs.push_back(RULE_T2 + "[b]" + case_method_name + "[/b]")
			logs.push_back(RULE_B2 + "[bgcolor=#F00][color=#FFF]" + "Bad case: undefined." + "[/color][/bgcolor]")
			case_failed += 1
			continue

		_case_assert_results.clear()

		var case_params: Variant = _case_params.get(case_method_name)
		if case_params == null:
			await call(case_method_name)
		else:
			await callv(case_method_name, _case_params.get(case_method_name))

		var case_assert_failed := 0
		var case_assert_passed := 0
		for result: Dictionary in _case_assert_results:
			if result.condition:
				case_assert_passed += 1
			else:
				case_assert_failed += 1

		if 0 < case_assert_failed:
			logs.push_back(RULE_T2 + "[b]" + case_method_name + "[/b]")
			for result: Dictionary in _case_assert_results:
				if not result.condition:
					var stacktrace: ScriptBacktrace = result.stacktrace
					var stacktrace_offset: int = result.stacktrace_offset
					logs.push_back(RULE_M3 + "[bgcolor=#F00][color=#FFF]" + result.message + "[/color][/bgcolor]" + " [color=#888]at " + stacktrace.get_frame_file(stacktrace_offset) + ":" + str(stacktrace.get_frame_line(stacktrace_offset)) + "[/color]")
			logs.push_back(RULE_B2 + "[color=#888]" + str(case_assert_passed) + "/" + str(case_assert_passed + case_assert_failed) + " assert(s) passed." + "[/color]")
			case_failed += 1
		else:
			logs.push_back(RULE_M2 + "[b]" + case_method_name + "[/b]")
			case_passed += 1

	if 0 < case_failed:
		print_rich(RULE_T1 + "[color=#F00][b]" + _name + "[/b][/color]")
		@warning_ignore("shadowed_global_identifier")
		for log: String in logs:
			print_rich(log)
		print_rich(RULE_B1 + "[color=#888]" + str(case_passed) + "/" + str(case_passed + case_failed) + " case(s) passed." + "[/color]")
	else:
		print_rich(RULE_M1 + "[b]" + _name + "[/b]")
	return case_failed == 0

#-------------------------------------------------------------------------------

signal _deferred

static var _tree := Engine.get_main_loop() as SceneTree
static var _unrelated_method_names: Array[StringName] = []
var _name: StringName
var _case_params: Dictionary[StringName, Array] = {}
var _case_method_names: Array[StringName] = []
var _case_assert_results: Array[Dictionary] = []

func _init(name := &"") -> void:
	if _unrelated_method_names.is_empty():
		var dummy := RefCounted.new()
		for method: Dictionary in dummy.get_method_list():
			_unrelated_method_names.push_back(method.name)

		_unrelated_method_names.push_back(wait_defer.get_method())
		_unrelated_method_names.push_back(wait_defer_process.get_method())
		_unrelated_method_names.push_back(wait_defer_physics.get_method())
		_unrelated_method_names.push_back(wait_delay.get_method())

		_unrelated_method_names.push_back(is_true.get_method())
		_unrelated_method_names.push_back(is_false.get_method())
		_unrelated_method_names.push_back(is_null.get_method())
		_unrelated_method_names.push_back(is_not_null.get_method())
		_unrelated_method_names.push_back(is_instance_of_type.get_method())
		_unrelated_method_names.push_back(is_empty.get_method())
		_unrelated_method_names.push_back(is_not_empty.get_method())
		_unrelated_method_names.push_back(are_equal.get_method())

		_unrelated_method_names.push_back(set_params.get_method())
		_unrelated_method_names.push_back(unrelate.get_method())
		_unrelated_method_names.push_back(wait.get_method())

	if name.is_empty():
		var script: Script = get_script()
		_name = script.get_global_name()
	else:
		_name = name

	for method: Dictionary in get_method_list():
		if not method.name in _unrelated_method_names:
			_case_method_names.push_back(method.name)
