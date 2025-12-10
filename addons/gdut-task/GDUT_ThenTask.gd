class_name GDUT_ThenTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	antecedent: Task,
	init: Variant,
	name := &"Task.then") -> Task:

	if init is Array:
		match init.size():
			3 when init[0] is Object and (init[1] is String or init[1] is StringName):
				if init[0].has_method(init[1]):
					if init[2] is Array:
						return GDUT_ThenBoundMethodNameTask.create(
							antecedent,
							init[0],
							init[1],
							init[2],
							name)
			2 when init[0] is Object and (init[1] is String or init[1] is StringName):
				if init[0].has_method(init[1]):
					return GDUT_ThenMethodNameTask.create(
						antecedent,
						init[0],
						init[1],
						name)
			2 when init[0] is Callable:
				if init[1] is Array:
					return GDUT_ThenBoundMethodTask.create(
						antecedent,
						init[0],
						init[1],
						name)
			1 when init[0] is Awaitable:
				return new(antecedent, init[0], name)
			1 when init[0] is Object:
				if init[0].has_method(&"wait"):
					return GDUT_ThenMethodNameTask.create(
						antecedent,
						init[0],
						&"wait",
						name)
			1 when init[0] is Callable:
				return GDUT_ThenMethodTask.create(antecedent, init[0], name)
			1:
				return new(antecedent, init[0], name)
	if init is Awaitable:
		return new(antecedent, init, name)
	if init is Object:
		if init.has_method(&"wait"):
			return GDUT_ThenMethodNameTask.create(
				antecedent,
				init,
				&"wait",
				name)
	if init is Callable:
		return GDUT_ThenMethodTask.create(antecedent, init, name)
	return new(antecedent, init, name)

func finalize() -> void:
	if _antecedent_task is CustomTask:
		_antecedent_task.temporary_release(self)
	_antecedent_task = null
	if _continuation is CustomTask:
		_continuation.temporary_release(self)
	_continuation = null

#-------------------------------------------------------------------------------

var _antecedent_task: Awaitable
var _continuation: Variant

func _init(
	antecedent_task: Awaitable,
	continuation: Variant,
	name: StringName) -> void:

	super(name)

	_antecedent_task = antecedent_task
	_continuation = continuation
	_fork()

func _fork() -> void:
	var result: Variant = \
		await _antecedent_task.temporary_wait(self) \
		if _antecedent_task is CustomTask else \
		await _antecedent_task.wait(cascade_cancel)
	if is_pending:
		if _antecedent_task is Task:
			match _antecedent_task.get_state():
				STATE_COMPLETED:
					if _continuation is CustomTask:
						result = await _continuation.temporary_wait(self)
					elif _continuation is Awaitable:
						result = await _continuation.wait(cascade_cancel)
					else:
						result = _continuation
					if is_pending:
						if _continuation is Task:
							match _continuation.get_state():
								STATE_COMPLETED:
									release_complete(result)
								STATE_CANCELED:
									release_cancel()
								_:
									if not _continuation is CustomTask or not _continuation.is_pending:
										GDUT_Task.panic(
											&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT",
											_continuation)
									release_cancel()
						else:
							release_complete(result)
				STATE_CANCELED:
					release_cancel()
				_:
					if not _antecedent_task is CustomTask or not _antecedent_task.is_pending:
						GDUT_Task.panic(
							&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT",
							_antecedent_task)
					release_cancel()
		else:
			if _continuation is CustomTask:
				result = await _continuation.temporary_wait(self)
			elif _continuation is Awaitable:
				result = await _continuation.wait(cascade_cancel)
			else:
				result = _continuation
			if is_pending:
				if _continuation is Task:
					match _continuation.get_state():
						STATE_COMPLETED:
							release_complete(result)
						STATE_CANCELED:
							release_cancel()
						_:
							if not _continuation is CustomTask or not _continuation.is_pending:
								GDUT_Task.panic(
									&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT",
									_continuation)
							release_cancel()
				else:
					release_complete(result)
