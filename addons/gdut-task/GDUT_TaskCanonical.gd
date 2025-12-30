class_name GDUT_Task extends Node

#-------------------------------------------------------------------------------
#	SIGNALS
#-------------------------------------------------------------------------------

signal idle_frame(delta: float)
signal idle(delta: float)
signal physics_frame(delta: float)
signal physics(delta: float)

#-------------------------------------------------------------------------------
#	PROPERTIES
#-------------------------------------------------------------------------------

static var canonical: GDUT_Task:
	get:
		return _canonical

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func get_message_v(message_name: StringName, message_args: Array) -> String:
	var message: String
	if _canonical != null:
		message = _canonical._translation_domain.translate(message_name)
	else:
		var translation: Translation = _TRANSLATIONS.front()
		message = translation.get_message(message_name)
	if not message_args.is_empty():
		message = message.format(message_args)
	return message

static func get_message(message_name: StringName, ...message_args: Array) -> String:
	return get_message_v(message_name, message_args)

static func print_error(message_name: StringName, ...message_args: Array) -> void:
	if _canonical != null and not _canonical._suppress_error_message:
		push_error(get_message_v(message_name, message_args))

static func print_fatal(message_name: StringName, ...message_args: Array) -> void:
	if _canonical != null and not _canonical._suppress_fatal_message:
		print_debug(get_message_v(message_name, message_args))
	breakpoint

@warning_ignore("unused_parameter")
static func validate_task_from_method_0(method: Callable) -> bool:
	return true

static func validate_task_from_method_1(method: Callable) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation and \
		not _is_lambda(method):

		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		match method_info_args[0].type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

@warning_ignore("unused_parameter")
static func validate_task_from_method_name_0(object: Object, method_name: StringName) -> bool:
	return true

static func validate_task_from_method_name_1(object: Object, method_name: StringName) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation:

		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		match method_info_args[0].type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func validate_task_from_bound_method_0(method: Callable, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation and \
		not _is_lambda(method):

		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func validate_task_from_bound_method_1(method: Callable, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation and \
		not _is_lambda(method):

		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
		match method_info_args.back().type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func validate_task_from_bound_method_name_0(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation:

		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func validate_task_from_bound_method_name_1(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation:

		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
		match method_info_args.back().type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func validate_task_from_filtered_signal(signal_: Signal, filter_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_signal_validation:

		var object := signal_.get_object()
		var signal_name := signal_.get_name()
		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_task_wildcard():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

static func validate_task_from_filtered_signal_name(object: Object, signal_name: StringName, filter_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_signal_validation:

		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_task_wildcard():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

@warning_ignore("unused_parameter")
static func validate_task_then_method_0(method: Callable) -> bool:
	return true

@warning_ignore("unused_parameter")
static func validate_task_then_method_1(method: Callable) -> bool:
	return true

static func validate_task_then_method_2(method: Callable) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation and \
		not _is_lambda(method):

		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		match method_info_args[2].type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

@warning_ignore("unused_parameter")
static func validate_task_then_method_name_0(object: Object, method_name: StringName) -> bool:
	return true

@warning_ignore("unused_parameter")
static func validate_task_then_method_name_1(object: Object, method_name: StringName) -> bool:
	return true

static func validate_task_then_method_name_2(object: Object, method_name: StringName) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation:

		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		match method_info_args[2].type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func validate_task_then_bound_method_0(method: Callable, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation and \
		not _is_lambda(method):

		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func validate_task_then_bound_method_1(method: Callable, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation and \
		not _is_lambda(method):

		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func validate_task_then_bound_method_2(method: Callable, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation and \
		not _is_lambda(method):

		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
		match method_info_args.back().type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func validate_task_then_bound_method_name_0(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation:

		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func validate_task_then_bound_method_name_1(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation:

		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func validate_task_then_bound_method_name_2(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_method_validation:

		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
		match method_info_args.back().type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func validate_cancel_from_filtered_signal(signal_: Signal, filter_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_signal_validation:

		var object := signal_.get_object()
		var signal_name := signal_.get_name()
		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_cancel_wildcard():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

static func validate_cancel_from_filtered_signal_name(object: Object, signal_name: StringName, filter_args: Array) -> bool:
	if \
		_canonical != null and \
		_canonical._enable_strict_signal_validation:

		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_cancel_wildcard():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

static func get_task_wildcard() -> Object:
	return Task

static func get_cancel_wildcard() -> Object:
	return Cancel

static func match_task_signal_args(args: Array, filter_args: Array) -> bool:
	if args.size() != filter_args.size():
		return false
	for index: int in filter_args.size():
		var arg: Variant = args[index]
		var arg_type := typeof(arg)
		var filter_arg: Variant = filter_args[index]
		var filter_arg_type := typeof(filter_arg)
		match filter_arg_type:
			TYPE_NIL:
				if arg_type != TYPE_NIL:
					return false
			TYPE_STRING, \
			TYPE_STRING_NAME:
				if arg_type != TYPE_STRING and arg_type != TYPE_STRING_NAME or arg != filter_arg:
					return false
			TYPE_OBJECT:
				if filter_arg == get_task_wildcard():
					continue
				if arg_type != TYPE_OBJECT or filter_arg != arg:
					return false
			_:
				if not is_same(arg, filter_arg):
					return false
	return true

static func match_cancel_signal_args(args: Array, filter_args: Array) -> bool:
	if args.size() != filter_args.size():
		return false
	for index: int in filter_args.size():
		var arg: Variant = args[index]
		var arg_type := typeof(arg)
		var filter_arg: Variant = filter_args[index]
		var filter_arg_type := typeof(filter_arg)
		match filter_arg_type:
			TYPE_NIL:
				if arg_type != TYPE_NIL:
					return false
			TYPE_STRING, \
			TYPE_STRING_NAME:
				if arg_type != TYPE_STRING and arg_type != TYPE_STRING_NAME or arg != filter_arg:
					return false
			TYPE_OBJECT:
				if filter_arg == get_cancel_wildcard():
					continue
				if arg_type != TYPE_OBJECT or filter_arg != arg:
					return false
			_:
				if not is_same(arg, filter_arg):
					return false
	return true

static func create_timer(
	timeout: float,
	ignore_pause: bool,
	ignore_time_scale: bool) -> SceneTreeTimer:

	var tree: SceneTree = \
		Engine.get_main_loop() \
		if _canonical == null else \
		_canonical.get_tree()
	return tree.create_timer(
		timeout,
		ignore_pause,
		false,
		ignore_time_scale)

func monitor_cancel(cancel: MonitoredCustomCancel) -> void:
	if _monitor_enable:
		_monitor_cancel_weaks.push_back(weakref(cancel))

func monitor_task(task: MonitoredCustomTask) -> void:
	if _monitor_enable:
		_monitor_task_weaks.push_back(weakref(task))

#-------------------------------------------------------------------------------

const _TRANSLATIONS: Array[Translation] = [
	preload("plugin.en.translation"),
	preload("plugin.ja.translation"),
]

const _VALID_ARG_TYPES_MAP: Dictionary[int, Array] = {
	TYPE_NIL: [
		TYPE_NIL,
		TYPE_BOOL,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_VECTOR2,
		TYPE_VECTOR2I,
		TYPE_RECT2,
		TYPE_RECT2I,
		TYPE_VECTOR3,
		TYPE_VECTOR3I,
		TYPE_TRANSFORM2D,
		TYPE_VECTOR4,
		TYPE_VECTOR4I,
		TYPE_PLANE,
		TYPE_QUATERNION,
		TYPE_AABB,
		TYPE_BASIS,
		TYPE_TRANSFORM3D,
		TYPE_PROJECTION,
		TYPE_COLOR,
		TYPE_STRING_NAME,
		TYPE_NODE_PATH,
		TYPE_RID,
		TYPE_OBJECT,
		TYPE_CALLABLE,
		TYPE_SIGNAL,
		TYPE_DICTIONARY,
		TYPE_ARRAY,
		TYPE_PACKED_BYTE_ARRAY,
		TYPE_PACKED_INT32_ARRAY,
		TYPE_PACKED_INT64_ARRAY,
		TYPE_PACKED_FLOAT32_ARRAY,
		TYPE_PACKED_FLOAT64_ARRAY,
		TYPE_PACKED_STRING_ARRAY,
		TYPE_PACKED_VECTOR2_ARRAY,
		TYPE_PACKED_VECTOR3_ARRAY,
		TYPE_PACKED_COLOR_ARRAY,
		TYPE_PACKED_VECTOR4_ARRAY,
	],
	TYPE_BOOL: [TYPE_BOOL, TYPE_INT, TYPE_FLOAT],
	TYPE_INT: [TYPE_BOOL, TYPE_INT, TYPE_FLOAT],
	TYPE_FLOAT: [TYPE_BOOL, TYPE_INT, TYPE_FLOAT],
	TYPE_STRING: [TYPE_STRING, TYPE_STRING_NAME, TYPE_NODE_PATH],
	TYPE_VECTOR2: [TYPE_VECTOR2, TYPE_VECTOR2I],
	TYPE_VECTOR2I: [TYPE_VECTOR2, TYPE_VECTOR2I],
	TYPE_RECT2: [TYPE_RECT2, TYPE_RECT2I],
	TYPE_RECT2I: [TYPE_RECT2, TYPE_RECT2I],
	TYPE_VECTOR3: [TYPE_VECTOR3, TYPE_VECTOR3I],
	TYPE_VECTOR3I: [TYPE_VECTOR3, TYPE_VECTOR3I],
	TYPE_TRANSFORM2D: [TYPE_TRANSFORM2D],
	TYPE_VECTOR4: [TYPE_VECTOR4, TYPE_VECTOR4I],
	TYPE_VECTOR4I: [TYPE_VECTOR4, TYPE_VECTOR4I],
	TYPE_PLANE: [TYPE_PLANE],
	TYPE_QUATERNION: [TYPE_QUATERNION],
	TYPE_AABB: [TYPE_AABB],
	TYPE_BASIS: [TYPE_BASIS],
	TYPE_TRANSFORM3D: [TYPE_BASIS, TYPE_TRANSFORM3D],
	TYPE_PROJECTION: [TYPE_TRANSFORM3D, TYPE_PROJECTION],
	TYPE_COLOR: [TYPE_INT, TYPE_STRING, TYPE_COLOR],
	TYPE_STRING_NAME: [TYPE_STRING, TYPE_STRING_NAME],
	TYPE_NODE_PATH: [TYPE_STRING, TYPE_NODE_PATH],
	TYPE_RID: [TYPE_RID],
	TYPE_OBJECT: [TYPE_NIL, TYPE_OBJECT],
	TYPE_CALLABLE: [TYPE_CALLABLE],
	TYPE_SIGNAL: [TYPE_SIGNAL],
	TYPE_DICTIONARY: [TYPE_DICTIONARY],
	TYPE_ARRAY: [
		TYPE_ARRAY,
		TYPE_PACKED_BYTE_ARRAY,
		TYPE_PACKED_INT32_ARRAY,
		TYPE_PACKED_INT64_ARRAY,
		TYPE_PACKED_FLOAT32_ARRAY,
		TYPE_PACKED_FLOAT64_ARRAY,
		TYPE_PACKED_STRING_ARRAY,
		TYPE_PACKED_VECTOR2_ARRAY,
		TYPE_PACKED_VECTOR3_ARRAY,
		TYPE_PACKED_COLOR_ARRAY,
		TYPE_PACKED_VECTOR4_ARRAY,
	],
	TYPE_PACKED_BYTE_ARRAY: [TYPE_ARRAY, TYPE_PACKED_BYTE_ARRAY],
	TYPE_PACKED_INT32_ARRAY: [TYPE_ARRAY, TYPE_PACKED_INT32_ARRAY],
	TYPE_PACKED_INT64_ARRAY: [TYPE_ARRAY, TYPE_PACKED_INT64_ARRAY],
	TYPE_PACKED_FLOAT32_ARRAY: [TYPE_ARRAY, TYPE_PACKED_FLOAT32_ARRAY],
	TYPE_PACKED_FLOAT64_ARRAY: [TYPE_ARRAY, TYPE_PACKED_FLOAT64_ARRAY],
	TYPE_PACKED_STRING_ARRAY: [TYPE_ARRAY, TYPE_PACKED_STRING_ARRAY],
	TYPE_PACKED_VECTOR2_ARRAY: [TYPE_ARRAY, TYPE_PACKED_VECTOR2_ARRAY],
	TYPE_PACKED_VECTOR3_ARRAY: [TYPE_ARRAY, TYPE_PACKED_VECTOR3_ARRAY],
	TYPE_PACKED_COLOR_ARRAY: [TYPE_ARRAY, TYPE_PACKED_COLOR_ARRAY],
	TYPE_PACKED_VECTOR4_ARRAY: [TYPE_ARRAY, TYPE_PACKED_VECTOR4_ARRAY],
}

class _LambdaComparer:

	func is_same_method(method: Callable) -> bool:
		return _signal.is_connected(method)

	func is_same_method_name(object: Object, method_name: StringName) -> bool:
		return _signal.is_connected(Callable(object, method_name))

	#
	# Since the functionality provided by Callable alone cannot compare
	# named lambdas and class methods, so perform equivalence comparison of
	# the call destination by once connecting to a signal and checking if
	# it is connected.
	#

	signal _signal

	func _init(method: Callable) -> void:
		_signal.connect(method)

static var _canonical: GDUT_Task
var _translation_domain: TranslationDomain
var _monitor_enable: bool
var _monitor_max_recursion: int
var _monitor_force_finalize_when_addon_exit_tree: bool
var _monitor_cancel_weaks: Array[WeakRef]
var _monitor_task_weaks: Array[WeakRef]
var _monitor_indefinitely_pending_cancels: Array[MonitoredCustomCancel]
var _monitor_indefinitely_pending_tasks: Array[MonitoredCustomTask]
var _suppress_error_message: bool
var _suppress_fatal_message: bool
var _enable_strict_method_validation: bool
var _enable_strict_signal_validation: bool

static func _get_method_info(object: Object, method_name: StringName) -> Dictionary:
	assert(object.has_method(method_name))

	var method_info: Dictionary
	for method_info_candidate: Dictionary in object.get_method_list():
		if method_info_candidate.name == method_name:
			method_info = method_info_candidate
			break
	return method_info

static func _get_signal_info(object: Object, signal_name: StringName) -> Dictionary:
	assert(object.has_signal(signal_name))

	var signal_info: Dictionary
	for signal_info_candidate: Dictionary in object.get_signal_list():
		if signal_info_candidate.name == signal_name:
			signal_info = signal_info_candidate
			break
	return signal_info

static func _is_lambda(method: Callable) -> bool:
	const ANONYMOUS_LAMBDA_METHOD_NAME := &"<anonymous lambda>"

	if method.is_custom():
		var method_name := method.get_method()
		if method_name == ANONYMOUS_LAMBDA_METHOD_NAME:
			return true
		var object := method.get_object()
		if object is GDScript:
			if \
				not object.has_method(method_name) or \
				not _LambdaComparer.new(method).is_same_method_name(object, method_name):
				return true
	return false

func _patrol_monitoreds_walk(recursion: int) -> void:
	var remaining_cancel_weaks := 0
	var cancel_index := 0
	while cancel_index < _monitor_cancel_weaks.size():
		var cancel_weak := _monitor_cancel_weaks[cancel_index]
		if cancel_weak == null:
			cancel_index += 1
			continue
		var cancel := cancel_weak.get_ref() as MonitoredCustomCancel
		if cancel == null:
			_monitor_cancel_weaks[cancel_index] = null
			cancel_index += 1
			continue
		if not cancel.is_requested and cancel.is_indefinitely_pending:
			_monitor_cancel_weaks[cancel_index] = null
			_monitor_indefinitely_pending_cancels.push_back(cancel)
			cancel_index += 1
			continue
		cancel_index += 1
		remaining_cancel_weaks += 1
	if remaining_cancel_weaks == 0:
		_monitor_cancel_weaks.clear()

	var remaining_task_weaks := 0
	var task_index := 0
	while task_index < _monitor_task_weaks.size():
		var task_weak := _monitor_task_weaks[task_index]
		if task_weak == null:
			task_index += 1
			continue
		var task := task_weak.get_ref() as MonitoredCustomTask
		if task == null:
			_monitor_task_weaks[task_index] = null
			task_index += 1
			continue
		if task.is_pending and task.is_indefinitely_pending:
			_monitor_task_weaks[task_index] = null
			_monitor_indefinitely_pending_tasks.push_back(task)
			task_index += 1
			continue
		task_index += 1
		remaining_task_weaks += 1
	if remaining_cancel_weaks == 0:
		_monitor_task_weaks.clear()

	for cancel: MonitoredCustomCancel in _monitor_indefinitely_pending_cancels:
		cancel.request()
	_monitor_indefinitely_pending_cancels.clear()

	for task: MonitoredCustomTask in _monitor_indefinitely_pending_tasks:
		task.release_cancel()
	_monitor_indefinitely_pending_tasks.clear()

	if \
		not _monitor_cancel_weaks.is_empty() or \
		not _monitor_task_weaks.is_empty():

		recursion -= 1
		if 0 <= recursion:
			_patrol_monitoreds_walk.call_deferred(recursion)

func _patrol_monitoreds() -> void:
	_patrol_monitoreds_walk.call_deferred(_monitor_max_recursion)

func _enter_tree() -> void:
	_translation_domain = TranslationDomain.new()
	for translation: Translation in _TRANSLATIONS:
		_translation_domain.add_translation(translation)

	_monitor_enable = ProjectSettings.get_setting("gdut/task/monitor/enable", true)
	_monitor_max_recursion = ProjectSettings.get_setting("gdut/task/monitor/max_recursion", 3)
	_monitor_force_finalize_when_addon_exit_tree = ProjectSettings.get_setting("gdut/task/monitor/force_finalize_when_addon_exit_tree", true)
	_suppress_error_message = ProjectSettings.get_setting("gdut/task/debug/suppress_error_message", false)
	_suppress_fatal_message = ProjectSettings.get_setting("gdut/task/debug/suppress_fatal_message", false)
	_enable_strict_method_validation = ProjectSettings.get_setting("gdut/task/debug/enable_strict_method_validation", false)
	_enable_strict_signal_validation = ProjectSettings.get_setting("gdut/task/debug/enable_strict_signal_validation", false)

	_canonical = self

	var tree := get_tree()
	tree.process_frame.connect(_on_process_frame)
	tree.physics_frame.connect(_on_physics_frame)

func _exit_tree() -> void:
	if _monitor_enable:
		if _monitor_force_finalize_when_addon_exit_tree:
			if not _monitor_cancel_weaks.is_empty():
				for cancel_weak: WeakRef in _monitor_cancel_weaks:
					var cancel := cancel_weak.get_ref() as MonitoredCustomCancel
					if cancel != null:
						cancel.request()
				_monitor_cancel_weaks.clear()
			if not _monitor_task_weaks.is_empty():
				for task_weak: WeakRef in _monitor_task_weaks:
					var task := task_weak.get_ref() as MonitoredCustomTask
					if task != null:
						task.release_cancel()
				_monitor_task_weaks.clear()

	var tree := get_tree()
	tree.process_frame.disconnect(_on_process_frame)
	tree.physics_frame.disconnect(_on_physics_frame)

	_canonical = null

func _process(delta: float) -> void:
	if _monitor_enable:
		_patrol_monitoreds()
	idle.emit(delta)

func _physics_process(delta: float) -> void:
	if _monitor_enable:
		_patrol_monitoreds()
	physics.emit(delta)

func _on_process_frame() -> void:
	idle_frame.emit(get_process_delta_time())

func _on_physics_frame() -> void:
	physics_frame.emit(get_physics_process_delta_time())
