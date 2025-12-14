class_name GDUT_Task extends Node

#-------------------------------------------------------------------------------
#	SIGNALS
#-------------------------------------------------------------------------------

signal idle_frame(delta: float)
signal idle(delta: float)
signal physics_frame(delta: float)
signal physics(delta: float)

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func has_canonical() -> bool:
	return _canonical != null

@warning_ignore("unused_parameter")
static func is_valid_task_from_method_0(method: Callable) -> bool:
	return true

static func is_valid_task_from_method_1(method: Callable) -> bool:
	if _general_enable_strict_method_check and not _is_lambda(method):
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
static func is_valid_task_from_method_name_0(object: Object, method_name: StringName) -> bool:
	return true

static func is_valid_task_from_method_name_1(object: Object, method_name: StringName) -> bool:
	if _general_enable_strict_method_check:
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		match method_info_args[0].type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func is_valid_task_from_bound_method_0(method: Callable, bind_args: Array) -> bool:
	if _general_enable_strict_method_check and not _is_lambda(method):
		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func is_valid_task_from_bound_method_1(method: Callable, bind_args: Array) -> bool:
	if _general_enable_strict_method_check and not _is_lambda(method):
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

static func is_valid_task_from_bound_method_name_0(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if _general_enable_strict_method_check:
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func is_valid_task_from_bound_method_name_1(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if _general_enable_strict_method_check:
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

static func is_valid_task_from_filtered_signal(signal_: Signal, filter_args: Array) -> bool:
	if _general_enable_strict_signal_check:
		var object := signal_.get_object()
		var signal_name := signal_.get_name()
		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_skip():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

static func is_valid_task_from_filtered_signal_name(object: Object, signal_name: StringName, filter_args: Array) -> bool:
	if _general_enable_strict_signal_check:
		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_skip():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

@warning_ignore("unused_parameter")
static func is_valid_task_then_method_0(method: Callable) -> bool:
	return true

@warning_ignore("unused_parameter")
static func is_valid_task_then_method_1(method: Callable) -> bool:
	return true

static func is_valid_task_then_method_2(method: Callable) -> bool:
	if _general_enable_strict_method_check and not _is_lambda(method):
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
static func is_valid_task_then_method_name_0(object: Object, method_name: StringName) -> bool:
	return true

@warning_ignore("unused_parameter")
static func is_valid_task_then_method_name_1(object: Object, method_name: StringName) -> bool:
	return true

static func is_valid_task_then_method_name_2(object: Object, method_name: StringName) -> bool:
	if _general_enable_strict_method_check:
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		match method_info_args[2].type:
			TYPE_NIL, \
			TYPE_CALLABLE:
				pass
			_:
				return false
	return true

static func is_valid_task_then_bound_method_0(method: Callable, bind_args: Array) -> bool:
	if _general_enable_strict_method_check and not _is_lambda(method):
		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func is_valid_task_then_bound_method_1(method: Callable, bind_args: Array) -> bool:
	if _general_enable_strict_method_check and not _is_lambda(method):
		var object := method.get_object()
		var method_name := method.get_method()
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func is_valid_task_then_bound_method_2(method: Callable, bind_args: Array) -> bool:
	if _general_enable_strict_method_check and not _is_lambda(method):
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

static func is_valid_task_then_bound_method_name_0(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if _general_enable_strict_method_check:
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func is_valid_task_then_bound_method_name_1(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if _general_enable_strict_method_check:
		var method_info := _get_method_info(object, method_name)
		var method_info_args: Array = method_info.args
		for index: int in bind_args.size():
			var bind_arg: Variant = bind_args[index]
			if typeof(bind_arg) not in _VALID_ARG_TYPES_MAP[method_info_args[index].type]:
				return false
	return true

static func is_valid_task_then_bound_method_name_2(object: Object, method_name: StringName, bind_args: Array) -> bool:
	if _general_enable_strict_method_check:
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

static func is_valid_cancel_from_filtered_signal(signal_: Signal, filter_args: Array) -> bool:
	if _general_enable_strict_signal_check:
		var object := signal_.get_object()
		var signal_name := signal_.get_name()
		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_skip():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

static func is_valid_cancel_from_filtered_signal_name(object: Object, signal_name: StringName, filter_args: Array) -> bool:
	if _general_enable_strict_signal_check:
		var signal_info := _get_signal_info(object, signal_name)
		var signal_info_args: Array = signal_info.args
		if signal_info_args.size() != filter_args.size():
			return false
		for index: int in signal_info_args.size():
			var filter_arg: Variant = filter_args[index]
			if filter_arg is Object and filter_arg == get_skip():
				continue
			if typeof(filter_arg) not in _VALID_ARG_TYPES_MAP[signal_info_args[index].type]:
				return false
	return true

static func get_message_v(message_key: StringName, message_args: Array) -> String:
	if _translation_domain == null:
		_translation_domain = TranslationDomain.new()
		_add_translation(&"en", _TRANSLATION_EN)
		_add_translation(&"ja", _TRANSLATION_JA)

	var message: String = _translation_domain.translate(message_key)
	if not message_args.is_empty():
		message = message.format(message_args)
	return message

static func get_message(message_key: StringName, ...message_args: Array) -> String:
	return get_message_v(message_key, message_args)

static func get_skip() -> Object:
	return _skip

static func filter_signal_args(args: Array, filter_args: Array) -> bool:
	for i: int in filter_args.size():
		if not _match_arg(filter_args[i], args[i]):
			return false
	return true

static func get_workers_of(worker_class: Script) -> Array[Node]:
	assert(_canonical != null)
	var workers: Array[Node]
	for worker: Node in _canonical.get_children():
		if is_instance_of(worker, worker_class):
			workers.push_back(worker)
	return workers

static func add_worker(worker: Node) -> void:
	assert(_canonical != null)
	_canonical.add_child(worker)

static func get_idle_delta_time() -> float:
	assert(_canonical != null)
	return _canonical.get_process_delta_time()

static func get_physics_delta_time() -> float:
	assert(_canonical != null)
	return _canonical.get_physics_process_delta_time()

static func create_timer(
	timeout: float,
	ignore_pause: bool,
	ignore_time_scale: bool) -> SceneTreeTimer:

	assert(_canonical != null)
	return _tree.create_timer(
		timeout,
		ignore_pause,
		false,
		ignore_time_scale)

static func monitor_cancel(cancel: MonitoredCustomCancel) -> void:
	assert(_canonical != null)
	if _monitor_enable:
		_monitor_cancel_weaks.push_back(weakref(cancel))

static func monitor_task(task: MonitoredCustomTask) -> void:
	assert(_canonical != null)
	if _monitor_enable:
		_monitor_task_weaks.push_back(weakref(task))

static func connect_idle_frame(callable: Callable) -> void:
	assert(_canonical != null)
	_canonical.idle_frame.connect(callable)

static func connect_idle(callable: Callable) -> void:
	assert(_canonical != null)
	_canonical.idle.connect(callable)

static func connect_physics_frame(callable: Callable) -> void:
	assert(_canonical != null)
	_canonical.physics_frame.connect(callable)

static func connect_physics(callable: Callable) -> void:
	assert(_canonical != null)
	_canonical.physics.connect(callable)

static func disconnect_idle(callable: Callable) -> void:
	if _canonical != null:
		_canonical.idle.disconnect(callable)

static func disconnect_idle_frame(callable: Callable) -> void:
	if _canonical != null:
		_canonical.idle_frame.disconnect(callable)

static func disconnect_physics(callable: Callable) -> void:
	if _canonical != null:
		_canonical.physics.disconnect(callable)

static func disconnect_physics_frame(callable: Callable) -> void:
	if _canonical != null:
		_canonical.physics_frame.disconnect(callable)

#-------------------------------------------------------------------------------

#region translations

const _TRANSLATION_EN: Dictionary[StringName, String] = {
	&"BAD_CANONICAL": "The GDUT Task add-on is not enabled. (Some features require enabling the add-on)",
	&"BAD_INIT_ARRAY": "The INIT array is empty.",
	&"BAD_INIT": "An invalid INIT was specified.",
	&"BAD_TIMEOUT": "An invalid timeout was specified.",
	&"BAD_OBJECT": "An invalid object was specified.",
	&"BAD_OBJECT_ASSOCIATED_WITH_METHOD": "The object associated with the method is invalid.",
	&"BAD_OBJECT_ASSOCIATED_WITH_SIGNAL": "The object associated with the signal is invalid.",
	&"BAD_METHOD_NAME": "An invalid method '{0}' was specified.",
	&"BAD_METHOD_ARGC": "An invalid argument count {1} was specified for method '{0}'.",
	&"BAD_METHOD_ARGS": "An invalid method '{0}' signature.",
	&"BAD_SIGNAL_NAME": "An invalid signal '{0}' was specified.",
	&"BAD_SIGNAL_MATCH": "An invalid match was specified for signal '{0}'.",
	&"BAD_UNWRAP_DEPTH": "An invalid unwrap count was specified.",
	&"BAD_STATE_RETURNED_BY_ANTECEDENT": "The input source task {0} returned an unknown state. (There is an implementation issue)",
	&"BAD_STATE_RETURNED_BY_INIT": "The input {1}th INIT task {0} returned an unknown state. (There is an implementation issue)",
	&"TASK_STATE_PENDING": "(Pending)",
	&"TASK_STATE_PENDING_WITH_WAITERS": "(Pending with waiters)",
	&"TASK_STATE_CANCELED": "(Canceled)",
	&"TASK_STATE_COMPLETED": "(Completed)",
	&"TASK_RESOURCE_LOADER_BAD_RESOURCE": "Attempted to load an invalid resource '{0}' ({1}).",
	&"TASK_RESOURCE_LOADER_FAILED": "Some error occurred while loading resource '{0}' ({1}).",
	&"CANCEL_STATE_PENDING": "(Pending)",
	&"CANCEL_STATE_REQUESTED": "(Requested)",
}

const _TRANSLATION_JA: Dictionary[StringName, String] = {
	&"BAD_CANONICAL": "GDUT Task アドオンは有効化されていません。(いくつかの機能はアドオンを有効化する必要があります)",
	&"BAD_INIT_ARRAY": "INIT 配列が空です。",
	&"BAD_INIT": "不正な INIT を指定しました。",
	&"BAD_TIMEOUT": "不正なタイムアウトを指定しました。",
	&"BAD_OBJECT": "不正なオブジェクトを指定しました。",
	&"BAD_OBJECT_ASSOCIATED_WITH_METHOD": "メソッドに関連付けられているオブジェクトが無効です。",
	&"BAD_OBJECT_ASSOCIATED_WITH_SIGNAL": "シグナルに関連付けられているオブジェクトが無効です。",
	&"BAD_METHOD_NAME": "不正なメソッド '{0}' を指定しました。",
	&"BAD_METHOD_ARGC": "メソッド '{0}' に対し、不正な引数数 {1} を指定しました。",
	&"BAD_METHOD_ARGS": "メソッド '{0}' のシグネチャは無効です。",
	&"BAD_SIGNAL_NAME": "不正なシグナル '{0}' を指定しました。",
	&"BAD_SIGNAL_MATCH": "シグナル '{0}' に対し、不正なマッチを指定しました。",
	&"BAD_UNWRAP_DEPTH": "無効なアンラップ回数を指定しました。",
	&"BAD_STATE_RETURNED_BY_ANTECEDENT": "入力したソースタスク {0} が不明な状態を返しました。(実装に問題があります)",
	&"BAD_STATE_RETURNED_BY_INIT": "入力した {1} 番目の INIT タスク {0} が不明な状態を返しました。(実装に問題があります)",
	&"TASK_STATE_PENDING": "(未決定)",
	&"TASK_STATE_PENDING_WITH_WAITERS": "(未決定、待機有り)",
	&"TASK_STATE_CANCELED": "(キャンセル)",
	&"TASK_STATE_COMPLETED": "(完了)",
	&"TASK_RESOURCE_LOADER_BAD_RESOURCE": "不正なリソース '{0}' ({1}) を読み込もうとしました。",
	&"TASK_RESOURCE_LOADER_FAILED": "リソース '{0}' ({1}) の読み込み中に何らかのエラーが発生しました。",
	&"CANCEL_STATE_PENDING": "(未決定)",
	&"CANCEL_STATE_REQUESTED": "(要求済み)",
}

static func _add_translation(locale: StringName, translation_map: Dictionary[StringName, String]) -> void:
	var translation := Translation.new()
	translation.locale = locale
	for translation_key: StringName in translation_map:
		translation.add_message(translation_key, translation_map[translation_key])
	_translation_domain.add_translation(translation)

#endregion

#region validators

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

const _METHOD_NAME_ANONYMOUS_LAMBDA := &"<anonymous lambda>"

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

static func _is_lambda(method: Callable) -> bool:
	if method.is_custom():
		var method_name := method.get_method()
		if method_name == _METHOD_NAME_ANONYMOUS_LAMBDA:
			return true
		var object := method.get_object()
		if object is GDScript:
			if \
				not object.has_method(method_name) or \
				not _LambdaComparer.new(method).is_same_method_name(object, method_name):
				return true
	return false

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

#endregion

static var _canonical: GDUT_Task
static var _tree: SceneTree
static var _translation_domain: TranslationDomain
static var _skip := Object.new()
static var _general_enable_strict_method_check: bool
static var _general_enable_strict_signal_check: bool
static var _monitor_enable: bool
static var _monitor_max_recursion: int
static var _monitor_force_finalize_when_addon_exit_tree: bool
static var _monitor_cancel_weaks: Array[WeakRef]
static var _monitor_task_weaks: Array[WeakRef]
static var _monitor_indefinitely_pending_cancels: Array[MonitoredCustomCancel]
static var _monitor_indefinitely_pending_tasks: Array[MonitoredCustomTask]

static func _match_arg(a: Variant, b: Variant) -> bool:
	match typeof(a):
		TYPE_OBJECT:
			if a == get_skip():
				return true
		TYPE_STRING, \
		TYPE_STRING_NAME:
			match typeof(b):
				TYPE_STRING, \
				TYPE_STRING_NAME:
					if a == b:
						return true
		_:
			if typeof(a) == typeof(b) and a == b:
				return true
	return false

static func _patrol_monitoreds_walk(recursion: int) -> void:
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

static func _patrol_monitoreds() -> void:
	_patrol_monitoreds_walk.call_deferred(_monitor_max_recursion)

func _enter_tree() -> void:
	_general_enable_strict_method_check = ProjectSettings.get_setting("gdut/task/general/enable_strict_method_check", false)
	_general_enable_strict_signal_check = ProjectSettings.get_setting("gdut/task/general/enable_strict_signal_check", false)
	_monitor_enable = ProjectSettings.get_setting("gdut/task/monitor/enable", true)
	_monitor_max_recursion = ProjectSettings.get_setting("gdut/task/monitor/max_recursion", 5)
	_monitor_force_finalize_when_addon_exit_tree = ProjectSettings.get_setting("gdut/task/monitor/force_finalize_when_addon_exit_tree", true)
	_canonical = self

	_tree = get_tree()
	_tree.process_frame.connect(_on_process_frame)
	_tree.physics_frame.connect(_on_physics_frame)

func _exit_tree() -> void:
	_tree.process_frame.disconnect(_on_process_frame)
	_tree.physics_frame.disconnect(_on_physics_frame)

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
	_general_enable_strict_method_check = false
	_general_enable_strict_signal_check = false
	_monitor_enable = false
	_canonical = null

func _process(delta: float) -> void:
	if _monitor_enable:
		_patrol_monitoreds()
	idle.emit(delta)

func _physics_process(delta: float) -> void:
	if _monitor_enable:
		_patrol_monitoreds()
	physics.emit(delta)

static func _on_process_frame() -> void:
	assert(_canonical != null)
	_canonical.idle_frame.emit(_canonical.get_process_delta_time())

static func _on_physics_frame() -> void:
	assert(_canonical != null)
	_canonical.physics_frame.emit(_canonical.get_physics_process_delta_time())
