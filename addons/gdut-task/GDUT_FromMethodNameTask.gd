class_name GDUT_FromMethodNameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	object: Object,
	method_name: StringName,
	name := &"Task.from_method_name") -> Task:

	#
	# 事前チェック
	#

	if not is_instance_valid(object):
		push_error(GDUT_Task.get_message(&"BAD_OBJECT"))
		return GDUT_CanceledTask.create(name)
	if not object.has_method(method_name):
		push_error(GDUT_Task.get_message(&"BAD_METHOD_NAME", method_name))
		return GDUT_CanceledTask.create(name)
	var method_argc := object.get_method_argument_count(method_name)
	match method_argc:
		0:
			if not GDUT_Task.is_valid_task_from_method_name_0(object, method_name):
				push_error(GDUT_Task.get_message(&"BAD_METHOD_ARGS", method_name))
				return GDUT_CanceledTask.create(name)
		1:
			if not GDUT_Task.is_valid_task_from_method_name_1(object, method_name):
				push_error(GDUT_Task.get_message(&"BAD_METHOD_ARGS", method_name))
				return GDUT_CanceledTask.create(name)
		_:
			push_error(GDUT_Task.get_message(
				&"BAD_METHOD_ARGC",
				method_name,
				method_argc))
			return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(object, method_name, method_argc, name)

func finalize() -> void:
	_object = null

#-------------------------------------------------------------------------------

var _object: Object

func _init(
	object: Object,
	method_name: StringName,
	method_argc: int,
	name: StringName) -> void:

	super(name)

	_object = object
	_fork(method_name, method_argc)

func _fork(method_name: StringName, method_argc: int) -> void:
	var result: Variant
	match method_argc:
		0:
			result = await _object.call(method_name)
		1:
			result = await _object.call(method_name, release_cancel)
	if is_pending:
		release_complete(result)
