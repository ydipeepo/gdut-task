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

static func get_canonical() -> GDUT_Task:
	assert(_canonical != null)
	return _canonical

func create_timer(
	timeout: float,
	ignore_pause: bool,
	ignore_time_scale: bool) -> SceneTreeTimer:

	return _tree.create_timer(
		timeout,
		ignore_pause,
		false,
		ignore_time_scale)

func monitor_cancel(cancel: MonitoredCustomCancel) -> void:
	if _monitor_enabled:
		_monitoring_cancel_weaks.push_back(weakref(cancel))

func monitor_task(task: MonitoredCustomTask) -> void:
	if _monitor_enabled:
		_monitoring_task_weaks.push_back(weakref(task))

func translate_v(message_key: StringName, message_args: Array) -> String:
	var message: String = _translation_domain.translate(message_key)
	if not message_args.is_empty():
		message = message.format(message_args)
	return message

func translate(message_key: StringName, ...message_args: Array) -> String:
	return translate_v(message_key, message_args)

static func error(message_key: StringName, ...message_args: Array) -> void:
	push_error(get_canonical().translate_v(message_key, message_args))

static func panic(message_key: StringName, ...message_args: Array) -> void:
	print_debug(get_canonical().translate_v(message_key, message_args))
	breakpoint

#-------------------------------------------------------------------------------

const _TRANSLATION_EN: Dictionary[StringName, String] = {
	&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT": "The input source task {0} returned an unknown state. (There is an implementation issue)",
	&"UNKNOWN_STATE_RETURNED_BY_INIT": "The input {1}th INIT task {0} returned an unknown state. (There is an implementation issue)",
	&"EMPTY_INIT_ARRAY": "The INIT array is empty.",
	&"INVALID_INIT": "An invalid INIT was specified.",
	&"INVALID_TIMEOUT": "An invalid timeout was specified.",
	&"INVALID_OBJECT": "An invalid object was specified.",
	&"INVALID_OBJECT_ASSOCIATED_WITH_METHOD": "The object associated with the method is invalid.",
	&"INVALID_OBJECT_ASSOCIATED_WITH_SIGNAL": "The object associated with the signal is invalid.",
	&"INVALID_METHOD_NAME": "An invalid method '{0}' was specified.",
	&"INVALID_METHOD_ARGC": "An invalid argument count {1} was specified for method '{0}'.",
	&"INVALID_SIGNAL_NAME": "An invalid signal '{0}' was specified.",
	&"INVALID_SIGNAL_MATCH": "An invalid match was specified for signal '{0}'.",
	&"INVALID_UNWRAP_DEPTH": "An invalid unwrap count was specified.",
	&"TASK_RESOURCE_LOADER_INVALID_RESOURCE": "Attempted to load an invalid resource '{0}' ({1}).",
	&"TASK_RESOURCE_LOADER_FAILED": "Some error occurred while loading resource '{0}' ({1}).",
	&"TASK_STATE_PENDING": "(Pending)",
	&"TASK_STATE_PENDING_WITH_WAITERS": "(Pending with waiters)",
	&"TASK_STATE_CANCELED": "(Canceled)",
	&"TASK_STATE_COMPLETED": "(Completed)",
	&"CANCEL_STATE_PENDING": "(Pending)",
	&"CANCEL_STATE_REQUESTED": "(Requested)",
}

const _TRANSLATION_JA: Dictionary[StringName, String] = {
	&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT": "入力したソースタスク {0} が不明な状態を返しました。(実装に問題があります)",
	&"UNKNOWN_STATE_RETURNED_BY_INIT": "入力した {1} 番目の INIT タスク {0} が不明な状態を返しました。(実装に問題があります)",
	&"EMPTY_INIT_ARRAY": "INIT 配列が空です。",
	&"INVALID_INIT": "不正な INIT を指定しました。",
	&"INVALID_TIMEOUT": "不正なタイムアウトを指定しました。",
	&"INVALID_OBJECT": "不正なオブジェクトを指定しました。",
	&"INVALID_OBJECT_ASSOCIATED_WITH_METHOD": "メソッドに関連付けられているオブジェクトが無効です。",
	&"INVALID_OBJECT_ASSOCIATED_WITH_SIGNAL": "シグナルに関連付けられているオブジェクトが無効です。",
	&"INVALID_METHOD_NAME": "不正なメソッド '{0}' を指定しました。",
	&"INVALID_METHOD_ARGC": "メソッド '{0}' に対し、不正な引数数 {1} を指定しました。",
	&"INVALID_SIGNAL_NAME": "不正なシグナル '{0}' を指定しました。",
	&"INVALID_SIGNAL_MATCH": "シグナル '{0}' に対し、不正なマッチを指定しました。",
	&"INVALID_UNWRAP_DEPTH": "無効なアンラップ回数を指定しました。",
	&"TASK_RESOURCE_LOADER_INVALID_RESOURCE": "不正なリソース '{0}' ({1}) を読み込もうとしました。",
	&"TASK_RESOURCE_LOADER_FAILED": "リソース '{0}' ({1}) の読み込み中に何らかのエラーが発生しました。",
	&"TASK_STATE_PENDING": "(未決定)",
	&"TASK_STATE_PENDING_WITH_WAITERS": "(未決定、待機有り)",
	&"TASK_STATE_CANCELED": "(キャンセル)",
	&"TASK_STATE_COMPLETED": "(完了)",
	&"CANCEL_STATE_PENDING": "(未決定)",
	&"CANCEL_STATE_REQUESTED": "(要求済み)",
}

static var _canonical: Node

var _tree: SceneTree
var _translation_domain: TranslationDomain
var _monitor_enabled: bool
var _monitor_max_recursion: int
var _monitor_force_finalize_when_addon_exit_tree: bool
var _monitoring_cancel_weaks: Array[WeakRef]
var _monitoring_task_weaks: Array[WeakRef]
var _indefinitely_pending_cancels: Array[MonitoredCustomCancel]
var _indefinitely_pending_tasks: Array[MonitoredCustomTask]

func _add_translation(
	locale: StringName,
	translation_map: Dictionary[StringName, String]) -> void:

	var translation := Translation.new()
	translation.locale = locale
	for translation_key: StringName in translation_map:
		translation.add_message(translation_key, translation_map[translation_key])
	_translation_domain.add_translation(translation)

func _patrol_monitoreds_walk(recursion: int) -> void:
	var remaining_cancel_weaks := 0
	var cancel_index := 0
	while cancel_index < _monitoring_cancel_weaks.size():
		var cancel_weak := _monitoring_cancel_weaks[cancel_index]
		if cancel_weak == null:
			cancel_index += 1
			continue
		var cancel := cancel_weak.get_ref() as MonitoredCustomCancel
		if cancel == null:
			_monitoring_cancel_weaks[cancel_index] = null
			cancel_index += 1
			continue
		if not cancel.is_requested and cancel.is_indefinitely_pending:
			_monitoring_cancel_weaks[cancel_index] = null
			_indefinitely_pending_cancels.push_back(cancel)
			cancel_index += 1
			continue
		cancel_index += 1
		remaining_cancel_weaks += 1
	if remaining_cancel_weaks == 0:
		_monitoring_cancel_weaks.clear()

	var remaining_task_weaks := 0
	var task_index := 0
	while task_index < _monitoring_task_weaks.size():
		var task_weak := _monitoring_task_weaks[task_index]
		if task_weak == null:
			task_index += 1
			continue
		var task := task_weak.get_ref() as MonitoredCustomTask
		if task == null:
			_monitoring_task_weaks[task_index] = null
			task_index += 1
			continue
		if task.is_pending and task.is_indefinitely_pending:
			_monitoring_task_weaks[task_index] = null
			_indefinitely_pending_tasks.push_back(task)
			task_index += 1
			continue
		task_index += 1
		remaining_task_weaks += 1
	if remaining_cancel_weaks == 0:
		_monitoring_task_weaks.clear()

	for cancel: MonitoredCustomCancel in _indefinitely_pending_cancels:
		cancel.request()
	_indefinitely_pending_cancels.clear()

	for task: MonitoredCustomTask in _indefinitely_pending_tasks:
		task.release_cancel()
	_indefinitely_pending_tasks.clear()

	if \
		not _monitoring_cancel_weaks.is_empty() or \
		not _monitoring_task_weaks.is_empty():

		recursion -= 1
		if 0 <= recursion:
			_patrol_monitoreds_walk.call_deferred(recursion)

func _patrol_monitoreds() -> void:
	_patrol_monitoreds_walk.call_deferred(_monitor_max_recursion)

func _enter_tree() -> void:
	_translation_domain = TranslationDomain.new()
	_add_translation(&"en", _TRANSLATION_EN)
	_add_translation(&"ja", _TRANSLATION_JA)

	_monitor_enabled = ProjectSettings.get_setting("gdut/task/monitor/enabled", true)
	_monitor_max_recursion = ProjectSettings.get_setting("gdut/task/monitor/max_recursion", 5)
	_monitor_force_finalize_when_addon_exit_tree = ProjectSettings.get_setting("gdut/task/monitor/force_finalize_when_addon_exit_tree", true)

	_tree = Engine.get_main_loop()
	_tree.process_frame.connect(_on_process_frame)
	_tree.physics_frame.connect(_on_physics_frame)

	_canonical = self

func _exit_tree() -> void:
	_tree.process_frame.disconnect(_on_process_frame)
	_tree.physics_frame.disconnect(_on_physics_frame)
	_tree = null

	if _monitor_enabled and _monitor_force_finalize_when_addon_exit_tree:
		if not _monitoring_cancel_weaks.is_empty():
			for cancel_weak: WeakRef in _monitoring_cancel_weaks:
				var cancel := cancel_weak.get_ref() as MonitoredCustomCancel
				if cancel != null:
					cancel.request()
			_monitoring_cancel_weaks.clear()

		if not _monitoring_task_weaks.is_empty():
			for task_weak: WeakRef in _monitoring_task_weaks:
				var task := task_weak.get_ref() as MonitoredCustomTask
				if task != null:
					task.release_cancel()
			_monitoring_task_weaks.clear()

	_canonical = null

func _process(delta: float) -> void:
	idle.emit(delta)

func _physics_process(delta: float) -> void:
	physics.emit(delta)

func _on_process_frame() -> void:
	if _monitor_enabled:
		_patrol_monitoreds()

	idle_frame.emit(get_process_delta_time())

func _on_physics_frame() -> void:
	if _monitor_enabled:
		_patrol_monitoreds()

	physics_frame.emit(get_physics_process_delta_time())
