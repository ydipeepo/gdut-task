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
		GDUT_Task.error(&"INVALID_OBJECT_ASSOCIATED_WITH_METHOD")
		return GDUT_CanceledTask.create(name)
	var method_argc := method.get_argument_count()
	match method_argc:
		0, \
		1:
			pass
		_:
			GDUT_Task.error(
				&"INVALID_METHOD_ARGC",
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
