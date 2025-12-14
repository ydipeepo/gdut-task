class_name GDUT_UnwrapTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	antecedent_task: Awaitable,
	depth: int,
	name := &"Task.unwrap") -> Task:

	#
	# 事前チェック
	#

	if depth < 0:
		push_error(GDUT_Task.get_message(&"BAD_UNWRAP_DEPTH"))
		return GDUT_CanceledTask.new(name)
	if depth == 0:
		return GDUT_FromTask.create(antecedent_task)

	#
	# タスク作成
	#

	return new(antecedent_task, depth, name)

func finalize() -> void:
	if _unwrapping_task is CustomTask:
		_unwrapping_task.temporary_release(self)
	_unwrapping_task = null

#-------------------------------------------------------------------------------

var _unwrapping_task: Awaitable

func _init(antecedent_task: Awaitable, depth: int, name: StringName) -> void:
	super(name)

	_unwrapping_task = antecedent_task
	_fork(depth)

func _fork(depth: int) -> void:
	while true:
		var result: Variant = \
			await _unwrapping_task.temporary_wait(self) \
			if _unwrapping_task is CustomTask else \
			await _unwrapping_task.wait(cascade_cancel)
		if is_pending:
			if _unwrapping_task is Task:
				match _unwrapping_task.get_state():
					STATE_COMPLETED:
						if result is Awaitable and depth != 0:
							_unwrapping_task = result
							depth -= 1
							continue
						release_complete(result)
					STATE_CANCELED:
						release_cancel()
					_:
						if not _unwrapping_task is CustomTask or not _unwrapping_task.is_pending:
							print_debug(GDUT_Task.get_message(
								&"BAD_STATE_RETURNED_BY_ANTECEDENT",
								_unwrapping_task))
							breakpoint
						release_cancel()
			else:
				if result is Awaitable and depth != 0:
					_unwrapping_task = result
					depth -= 1
					continue
				release_complete(result)
		break
