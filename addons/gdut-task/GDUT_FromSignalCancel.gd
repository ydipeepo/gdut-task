class_name GDUT_FromSignalCancel extends MonitoredCustomCancel

#------------------------------------------------------------------------------
#	METHODS
#------------------------------------------------------------------------------

static func create(signal_: Signal, name := &"Cancel.from_signal") -> Cancel:
	#
	# 事前チェック
	#

	if not is_instance_valid(signal_.get_object()) or signal_.is_null():
		GDUT_Task.error(&"INVALID_OBJECT_ASSOCIATED_WITH_SIGNAL")
		return GDUT_CanceledCancel.create(name)

	#
	# キャンセル作成
	#

	return new(signal_, name)

func get_indefinitely_pending() -> bool:
	return not is_instance_valid(_signal.get_object()) or _signal.is_null()

func finalize() -> void:
	if is_instance_valid(_signal.get_object()) and not _signal.is_null():
		_signal.disconnect(_on_completed)

#------------------------------------------------------------------------------

var _signal: Signal

func _init(signal_: Signal, name: StringName) -> void:
	super(name)

	_signal = signal_
	_signal.connect(_on_completed)

@warning_ignore("unused_parameter")
func _on_completed(...args: Array) -> void:
	request()
