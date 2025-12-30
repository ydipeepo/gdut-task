class_name GDUT_FromFilteredSignalTask extends MonitoredCustomTask

#--------------------------------------------------------------------------------
#	METHODS
#--------------------------------------------------------------------------------

static func create(
	signal_: Signal,
	filter_args: Array,
	name := &"Task.from_filtered_signal") -> Task:

	#
	# 事前チェック
	#

	if not is_instance_valid(signal_.get_object()) or signal_.is_null():
		GDUT_Task.print_error(&"BAD_OBJECT_ASSOCIATED_WITH_SIGNAL")
		return GDUT_CanceledTask.create(name)
	if not GDUT_Task.validate_task_from_filtered_signal(signal_, filter_args):
		GDUT_Task.print_error(
			&"SIGNAL_SIGNATURE_NOT_MATCH",
			signal_.get_name())
		return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(signal_, filter_args, name)

func get_indefinitely_pending() -> bool:
	return not is_instance_valid(_signal.get_object()) or _signal.is_null()

func finalize() -> void:
	if is_instance_valid(_signal.get_object()) and not _signal.is_null():
		_signal.disconnect(_on_completed)

#--------------------------------------------------------------------------------

var _filter_args: Array
var _signal: Signal

func _init(signal_: Signal, filter_args: Array, name: StringName) -> void:
	super(name)

	_filter_args = filter_args
	_signal = signal_
	_signal.connect(_on_completed)

func _on_completed(...args: Array) -> void:
	if args.size() != _filter_args.size():
		GDUT_Task.print_error(
			&"SIGNAL_SIGNATURE_NOT_MATCH",
			_signal.get_name())
		release_cancel()
	elif GDUT_Task.match_task_signal_args(args, _filter_args):
		release_complete(args)
