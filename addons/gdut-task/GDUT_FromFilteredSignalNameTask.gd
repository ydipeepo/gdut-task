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
		GDUT_Task.error(&"INVALID_OBJECT")
		return GDUT_CanceledTask.create(name)
	if not object.has_signal(signal_name):
		GDUT_Task.error(&"INVALID_SIGNAL_NAME", signal_name)
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
		GDUT_Task.error(&"INVALID_SIGNAL_MATCH", _signal_name)
		release_cancel()
	elif _match(args):
		release_complete(args)
