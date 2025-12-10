class_name GDUT_ThenBoundMethodTask extends MonitoredCustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	antecedent_task: Awaitable,
	method: Callable,
	bind_args: Array,
	name := &"Task.then_bound_method") -> Task:

	#
	# 事前チェック
	#

	if bind_args.is_empty():
		return GDUT_ThenMethodTask.create(antecedent_task, method, name)
	if not method.is_valid():
		GDUT_Task.error(&"INVALID_OBJECT_ASSOCIATED_WITH_METHOD")
		return GDUT_CanceledTask.create(name)
	var method_argc := method.get_argument_count()
	match method_argc - bind_args.size():
		0, \
		1, \
		2:
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

	return new(
		antecedent_task,
		method,
		method_argc,
		bind_args,
		name)

func get_indefinitely_pending() -> bool:
	return not _method.is_valid()

func finalize() -> void:
	if _antecedent_task is CustomTask:
		_antecedent_task.temporary_release(self)
	_antecedent_task = null

#-------------------------------------------------------------------------------

var _antecedent_task: Awaitable
var _method: Callable

func _init(
	antecedent_task: Awaitable,
	method: Callable,
	method_argc: int,
	bind_args: Array,
	name: StringName) -> void:

	super(name)

	_antecedent_task = antecedent_task
	_method = method
	_fork(method_argc, bind_args)

func _fork(method_argc: int, bind_args: Array) -> void:
	var result: Variant = \
		await _antecedent_task.temporary_wait(self) \
		if _antecedent_task is CustomTask else \
		await _antecedent_task.wait(cascade_cancel)
	if is_pending:
		if _antecedent_task is Task:
			match _antecedent_task.get_state():
				STATE_COMPLETED:
					if _method.is_valid():
						match method_argc - bind_args.size():
							0:
								result = await _method.callv(bind_args)
							1:
								result = await _method.callv(bind_args + [result])
							2:
								result = await _method.callv(bind_args + [result, release_cancel])
						if is_pending:
							if _method.is_valid():
								release_complete(result)
							else:
								release_cancel()
					else:
						release_cancel()
				STATE_CANCELED:
					release_cancel()
				_:
					if not _antecedent_task is CustomTask or not _antecedent_task.is_pending:
						GDUT_Task.panic(
							&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT",
							_antecedent_task)
					release_cancel()
		else:
			if _method.is_valid():
				match method_argc - bind_args.size():
					0:
						result = await _method.callv(bind_args)
					1:
						result = await _method.callv(bind_args + [result])
					2:
						result = await _method.callv(bind_args + [result, release_cancel])
				if is_pending:
					if _method.is_valid():
						release_complete(result)
					else:
						release_cancel()
			else:
				release_cancel()
