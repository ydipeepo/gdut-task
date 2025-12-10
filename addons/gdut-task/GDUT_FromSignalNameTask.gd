class_name GDUT_FromSignalNameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	object: Object,
	signal_name: StringName,
	name := &"Task.from_signal_name") -> Task:

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

	return new(object, signal_name, name)

func finalize() -> void:
	_object.disconnect(_signal_name, _on_completed)
	_object = null

#-------------------------------------------------------------------------------

var _object: Object
var _signal_name: StringName

func _init(object: Object, signal_name: StringName, name: StringName) -> void:
	super(name)

	_signal_name = signal_name
	_object = object
	_object.connect(_signal_name, _on_completed)

func _on_completed(...args: Array) -> void:
	release_complete(args)
