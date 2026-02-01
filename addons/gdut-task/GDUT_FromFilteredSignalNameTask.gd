class_name GDUT_FromFilteredSignalNameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	object: Object,
	signal_name: StringName,
	filter_args: Array,
	name := &"Task.from_filtered_signal_name") -> Task:

	#
	# 事前チェック
	#

	if not is_instance_valid(object):
		GDUT_Task.print_error(&"BAD_OBJECT")
		return GDUT_CanceledTask.create(name)
	if not object.has_signal(signal_name):
		GDUT_Task.print_error(
			&"BAD_SIGNAL_NAME",
			signal_name)
		return GDUT_CanceledTask.create(name)
	if not GDUT_Task.is_valid_task_from_filtered_signal_name(object, signal_name, filter_args):
		GDUT_Task.print_error(
			&"SIGNAL_SIGNATURE_NOT_MATCH",
			signal_name)
		return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(object, signal_name, filter_args, name)

func finalize() -> void:
	_object.disconnect(_signal_name, _on_completed)
	_object = null

#-------------------------------------------------------------------------------

var _object: Object
var _signal_name: StringName
var _filter_args: Array

func _init(
	object: Object,
	signal_name: StringName,
	filter_args: Array,
	name: StringName) -> void:

	super(name)

	_signal_name = signal_name
	_filter_args = filter_args
	_object = object
	_object.connect(_signal_name, _on_completed)

func _on_completed(...args: Array) -> void:
	if args.size() != _filter_args.size():
		GDUT_Task.print_error(
			&"SIGNAL_SIGNATURE_NOT_MATCH",
			_signal_name)
		release_cancel()
	elif GDUT_Task.match_task_signal_args(args, _filter_args):
		release_complete(args)
