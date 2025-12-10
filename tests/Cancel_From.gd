class_name Cancel_From extends Test

class Callsite:

	signal completed

	var requested_count := 0

	func on_requested() -> void:
		requested_count += 1

func 状態遷移() -> void:
	var callsite := Callsite.new()
	var cancel := Cancel.from(Cancel.deferred())
	if not is_instance_of_type(cancel, GDUT_FromCancel):
		return
	cancel.requested.connect(callsite.on_requested)
	is_false(cancel.is_requested)
	are_equal(0, callsite.requested_count)
	await wait_defer()
	is_true(cancel.is_requested)
	are_equal(1, callsite.requested_count)

func 状態遷移_キャンセルあり_即時() -> void:
	var cancel := Cancel.from(Cancel.canceled())
	if not is_instance_of_type(cancel, GDUT_CanceledCancel):
		return
	is_true(cancel.is_requested)

func 状態遷移_キャンセルあり_遅延() -> void:
	var cancel := Cancel.from(Cancel.deferred())
	if not is_instance_of_type(cancel, GDUT_FromCancel):
		return
	is_false(cancel.is_requested)

func ディスパッチ先_from_signal_name() -> void:
	var callsite := Callsite.new()
	var cancel := Cancel.from(callsite)
	if not is_instance_of_type(cancel, GDUT_FromSignalNameCancel):
		return
	is_false(cancel.is_requested)

func ディスパッチ先_from_signal_name_名前指定あり() -> void:
	var callsite := Callsite.new()
	var cancel := Cancel.from(callsite, callsite.completed.get_name())
	if not is_instance_of_type(cancel, GDUT_FromSignalNameCancel):
		return
	is_false(cancel.is_requested)

func ディスパッチ先_from_signal_name_名前指定あり_空() -> void:
	var callsite := Callsite.new()
	var cancel := Cancel.from(callsite, &"")
	if not is_instance_of_type(cancel, GDUT_CanceledCancel):
		return
	is_true(cancel.is_requested)

func ディスパッチ先_from_signal_name_名前指定あり_未定義() -> void:
	var callsite := Callsite.new()
	var cancel := Cancel.from(callsite, &"UNDEFINED")
	if not is_instance_of_type(cancel, GDUT_CanceledCancel):
		return
	is_true(cancel.is_requested)

func ディスパッチ先_from_signal() -> void:
	var callsite := Callsite.new()
	var cancel := Cancel.from(callsite.completed)
	if not is_instance_of_type(cancel, GDUT_FromSignalCancel):
		return
	is_false(cancel.is_requested)

func ディスパッチ先_from_signal_空() -> void:
	var cancel := Cancel.from(Signal())
	if not is_instance_of_type(cancel, GDUT_CanceledCancel):
		return
	is_true(cancel.is_requested)

func ディスパッチ先_canceled() -> void:
	var cancel := Cancel.from()
	if not is_instance_of_type(cancel, GDUT_CanceledCancel):
		return
	is_true(cancel.is_requested)

func スコープ() -> void:
	var cancel: Cancel
	if "scope":
		var callsite := Callsite.new()
		cancel = Cancel.from(callsite.completed)
		if not is_instance_of_type(cancel, GDUT_FromSignalCancel):
			return
		is_false(cancel.is_requested)
		are_equal(1, callsite.get_reference_count())
	is_false(cancel.is_requested)
	await wait_delay(0.1)
	is_true(cancel.is_requested)
