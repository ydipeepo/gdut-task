class_name GDUT_AnyTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(init_array: Array, name := &"Task.any") -> Task:
	#
	# 事前チェック
	#

	if init_array.is_empty():
		return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(init_array, name)

func finalize() -> void:
	for index: int in _task_array.size():
		var task := _task_array[index]
		if task is CustomTask:
			task.temporary_release(self)
	_task_array.clear()

#-------------------------------------------------------------------------------

var _task_array: Array[Awaitable]
var _pending: int

func _init(init_array: Array, name: StringName) -> void:
	super(name)

	var init_count := init_array.size()
	_task_array.resize(init_count)
	_pending = init_count
	for index: int in init_count:
		if not is_pending:
			break
		var init: Variant = init_array[index]
		var task: Awaitable = \
			init \
			if init is Awaitable else \
			GDUT_FromTask.create(init_array[index])
		_task_array[index] = task
		_fork(task, index)

func _fork(task: Awaitable, index: int) -> void:
	var result: Variant = \
		await task.temporary_wait(self) \
		if task is CustomTask else \
		await task.wait(cascade_cancel)
	if is_pending:
		if task is Task:
			match task.get_state():
				STATE_COMPLETED:
					release_complete(result)
				STATE_CANCELED:
					_pending -= 1
					if _pending == 0:
						release_cancel()
				_:
					if not task is CustomTask or not task.is_pending:
						GDUT_Task.panic(
							&"UNKNOWN_STATE_RETURNED_BY_INIT",
							task,
							index)
					release_cancel()
		else:
			release_complete(result)
