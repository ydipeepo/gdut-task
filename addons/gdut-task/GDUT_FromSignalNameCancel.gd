class_name GDUT_FromSignalNameCancel extends CustomCancel

#------------------------------------------------------------------------------
#	METHODS
#------------------------------------------------------------------------------

static func create(
	object: Object,
	signal_name: StringName,
	name := &"Cancel.from_signal_name") -> Cancel:

	#
	# 事前チェック
	#

	if not is_instance_valid(object):
		GDUT_Task.error(&"INVALID_OBJECT")
		return GDUT_CanceledCancel.create(name)
	if not object.has_signal(signal_name):
		GDUT_Task.error(&"INVALID_SIGNAL_NAME", signal_name)
		return GDUT_CanceledCancel.create(name)

	#
	# キャンセル作成
	#

	return new(object, signal_name, name)

func finalize() -> void:
	_object.disconnect(_signal_name, _on_completed)
	_object = null

#------------------------------------------------------------------------------

var _object: Object
var _signal_name: StringName

func _init(
	object: Object,
	signal_name: StringName,
	name: StringName) -> void:

	super(name)

	_signal_name = signal_name
	_object = object
	_object.connect(_signal_name, _on_completed)

@warning_ignore("unused_parameter")
func _on_completed(...args: Array) -> void:
	request()
