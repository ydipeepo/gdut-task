class_name Task_DeferIdleFrame extends Test

func 状態遷移() -> void:
	var task := Task.defer_idle_frame()
	if not is_not_null(task):
		return
	is_true(task.is_pending)
	var result: Variant = await task.wait()
	are_equal(GDUT_Task.get_idle_delta_time() if GDUT_Task.has_canonical() else 0.0, result)
	is_true(task.is_completed)

func 状態遷移_キャンセルあり_即時() -> void:
	var task := Task.defer_idle_frame()
	if not is_not_null(task):
		return
	is_true(task.is_pending)
	is_null(await task.wait(Cancel.canceled()))
	is_true(task.is_canceled)

func 状態遷移_キャンセルあり_遅延() -> void:
	var task := Task.defer_idle_frame()
	if not is_not_null(task):
		return
	is_true(task.is_pending)
	is_null(await task.wait(Cancel.deferred()))
	is_true(task.is_canceled)
