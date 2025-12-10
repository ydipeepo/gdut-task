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
		GDUT_Task.error(&"INVALID_OBJECT_ASSOCIATED_WITH_SIGNAL")
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

static func _match_arg(a: Variant, b: Variant) -> bool:
	match typeof(a):
		TYPE_OBJECT:
			if a == SKIP:
				return true
		TYPE_STRING, \
		TYPE_STRING_NAME:
			match typeof(b):
				TYPE_STRING, \
				TYPE_STRING_NAME:
					if a == b:
						return true
		_:
			if typeof(a) == typeof(b) and a == b:
				return true
	return false

func _match(args: Array) -> bool:
	for i: int in _filter_args.size():
		if not _match_arg(_filter_args[i], args[i]):
			return false
	return true

func _init(signal_: Signal, filter_args: Array, name: StringName) -> void:
	super(name)

	_filter_args = filter_args
	_signal = signal_
	_signal.connect(_on_completed)

func _on_completed(...args: Array) -> void:
	if args.size() != _filter_args.size():
		GDUT_Task.error(&"INVALID_SIGNAL_MATCH", _signal.get_name())
		release_cancel()
	elif _match(args):
		release_complete(args)
