class_name GDUT_MergedCancel extends CustomCancel

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(init_array: Array, name := &"Cancel.merged") -> Cancel:
	#
	# 事前チェック
	#

	match init_array.size():
		0:
			GDUT_Task.print_error(&"EMPTY_INIT_ARRAY")
			return GDUT_CanceledCancel.create(name)
		1:
			return GDUT_FromCancel.create(init_array.front(), name)
	var cancel_array: Array[Cancel] = []
	for init: Variant in init_array:
		var cancel := GDUT_FromCancel.create(init)
		if cancel.is_requested:
			return GDUT_CanceledCancel.create(name)
		cancel_array.push_back(cancel)

	#
	# キャンセル作成
	#

	return new(cancel_array)

func finalize() -> void:
	for cancel: Cancel in _cancel_array:
		cancel.requested.disconnect(request)
	_cancel_array.clear()

#-------------------------------------------------------------------------------

var _cancel_array: Array[Cancel]

func _init(cancel_array: Array[Cancel]) -> void:
	_cancel_array = cancel_array

	for cancel: Cancel in _cancel_array:
		cancel.requested.connect(request)
