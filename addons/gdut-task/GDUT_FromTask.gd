class_name GDUT_FromTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(init: Variant, name := &"Task.from") -> Task:
	if init is Array:
		match init.size():
			3 when init[0] is Object and (init[1] is String or init[1] is StringName):
				if init[0].has_method(init[1]):
					if init[2] is Array:
						return GDUT_FromBoundMethodNameTask.create(
							init[0],
							init[1],
							init[2],
							name)
				if init[0].has_signal(init[1]):
					if init[2] is Array:
						return GDUT_FromFilteredSignalNameTask.create(
							init[0],
							init[1],
							init[2],
							name)
			2 when init[0] is Object and (init[1] is String or init[1] is StringName):
				if init[0].has_method(init[1]):
					return GDUT_FromMethodNameTask.create(
						init[0],
						init[1],
						name)
				if init[0].has_signal(init[1]):
					return GDUT_FromSignalNameTask.create(
						init[0],
						init[1],
						name)
			2 when init[0] is Callable:
				if init[1] is Array:
					return GDUT_FromBoundMethodTask.create(
						init[0],
						init[1],
						name)
			2 when init[0] is Signal:
				if init[1] is Array:
					return GDUT_FromFilteredSignalTask.create(
						init[0],
						init[1],
						name)
			1 when init[0] is Object:
				if init[0] is Awaitable:
					return \
						GDUT_CanceledTask.create(name) \
						if init[0].is_canceled else \
						new(init[0], name)
				elif init[0].has_method(&"wait"):
					return GDUT_FromMethodNameTask.create(
						init[0],
						&"wait",
						name)
				elif init[0].has_signal(&"completed"):
					return GDUT_FromSignalNameTask.create(
						init[0],
						&"completed",
						name)
			1 when init[0] is Callable:
				return GDUT_FromMethodTask.create(init[0], name)
			1 when init[0] is Signal:
				return GDUT_FromSignalTask.create(init[0], name)
			1:
				return GDUT_CompletedTask.create(init[0], name)
	if init is Object:
		if init is Awaitable:
			return \
				GDUT_CanceledTask.create(name) \
				if init.is_canceled else \
				new(init, name)
		elif init.has_method(&"wait"):
			return GDUT_FromMethodNameTask.create(init, &"wait", name)
		elif init.has_signal(&"completed"):
			return GDUT_FromSignalNameTask.create(init, &"completed", name)
	if init is Callable:
		return GDUT_FromMethodTask.create(init, name)
	if init is Signal:
		return GDUT_FromSignalTask.create(init, name)
	return GDUT_CompletedTask.create(init, name)

func finalize() -> void:
	if _task is CustomTask:
		_task.temporary_release(self)
	_task = null

#-------------------------------------------------------------------------------

var _task: Awaitable

func _init(task: Awaitable, name: StringName) -> void:
	super(name)

	_task = task
	_fork()

func _fork() -> void:
	var result: Variant = \
		await _task.temporary_wait(self) \
		if _task is CustomTask else \
		await _task.wait(cascade_cancel)
	if is_pending:
		if _task is Task:
			match _task.get_state():
				STATE_COMPLETED:
					release_complete(result)
				STATE_CANCELED:
					release_cancel()
				_:
					if not _task is CustomTask or not _task.is_pending:
						GDUT_Task.panic(
							&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT",
							_task)
					release_cancel()
		else:
			release_complete(result)
