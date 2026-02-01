class_name GDUT_FromMethodTask extends MonitoredCustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	method: Callable,
	name := &"Task.from_method") -> Task:

	#
	# 事前チェック
	#

	if not method.is_valid():
		GDUT_Task.print_error(&"BAD_OBJECT_ASSOCIATED_WITH_METHOD")
		return GDUT_CanceledTask.create(name)
	var method_argc := method.get_argument_count()
	match method_argc:
		0:
			if not GDUT_Task.is_valid_task_from_method_0(method):
				GDUT_Task.print_error(
					&"BAD_METHOD_ARGUMENT_SIGNATURE",
					method.get_method())
				return GDUT_CanceledTask.create(name)
		1:
			if not GDUT_Task.is_valid_task_from_method_1(method):
				GDUT_Task.print_error(
					&"BAD_METHOD_ARGUMENT_SIGNATURE",
					method.get_method())
				return GDUT_CanceledTask.create(name)
		_:
			GDUT_Task.print_error(
				&"BAD_METHOD_ARGUMENT_COUNT",
				method.get_method(),
				method_argc)
			return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(method, method_argc, name)

func get_indefinitely_pending() -> bool:
	return not _method.is_valid()

func finalize() -> void:
	pass

#-------------------------------------------------------------------------------

var _method: Callable

func _init(method: Callable, method_argc: int, name: StringName) -> void:
	super(name)

	_method = method
	_fork(method_argc)

func _fork(method_argc: int) -> void:
	var result: Variant
	match method_argc:
		0:
			result = await _method.call()
		1:
			result = await _method.call(release_cancel)
	if is_pending:
		if _method.is_valid():
			release_complete(result)
		else:
			release_cancel()
