class_name Task_DeferIdle extends Test

func 状態遷移() -> void:
	var canonical: Node = Engine \
		.get_main_loop() \
		.root \
		.get_node(^"/root/GDUT_TaskCanonical")
	var task := Task.defer_idle()
	if not is_not_null(task):
		return
	is_true(task.is_pending)
	var result: Variant = await task.wait()
	are_equal(canonical.get_process_delta_time(), result)
	is_true(task.is_completed)

func 状態遷移_キャンセルあり_即時() -> void:
	var task := Task.defer_idle()
	if not is_not_null(task):
		return
	is_true(task.is_pending)
	is_null(await task.wait(Cancel.canceled()))
	is_true(task.is_canceled)

func 状態遷移_キャンセルあり_遅延() -> void:
	var task := Task.defer_idle()
	if not is_not_null(task):
		return
	is_true(task.is_pending)
	is_null(await task.wait(Cancel.deferred()))
	is_true(task.is_canceled)
