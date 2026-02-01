class_name GDUT_FromBoundMethodNameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	object: Object,
	method_name: StringName,
	bind_args: Array,
	name := &"Task.from_bound_method_name") -> Task:

	#
	# 事前チェック
	#

	if bind_args.is_empty():
		return GDUT_FromMethodNameTask.create(object, method_name, name)
	if not is_instance_valid(object):
		GDUT_Task.print_error(&"BAD_OBJECT")
		return GDUT_CanceledTask.create(name)
	if not object.has_method(method_name):
		GDUT_Task.print_error(
			&"BAD_METHOD_NAME",
			method_name)
		return GDUT_CanceledTask.create(name)
	var method_argc := object.get_method_argument_count(method_name)
	match method_argc - bind_args.size():
		0:
			if not GDUT_Task.is_valid_task_from_bound_method_name_0(
				object,
				method_name,
				bind_args):

				GDUT_Task.print_error(
					&"BAD_METHOD_ARGUMENT_SIGNATURE",
					method_name)
				return GDUT_CanceledTask.create(name)
		1:
			if not GDUT_Task.is_valid_task_from_bound_method_name_1(
				object,
				method_name,
				bind_args):

				GDUT_Task.print_error(
					&"BAD_METHOD_ARGUMENT_SIGNATURE",
					method_name)
				return GDUT_CanceledTask.create(name)
		_:
			GDUT_Task.print_error(
				&"BAD_METHOD_ARGUMENT_COUNT",
				method_name,
				method_argc - bind_args.size())
			return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(object, method_name, method_argc, bind_args, name)

func finalize() -> void:
	_object = null

#-------------------------------------------------------------------------------

var _object: Object

func _init(
	object: Object,
	method_name: StringName,
	method_argc: int,
	bind_args: Array,
	name: StringName) -> void:

	super(name)

	_object = object
	_fork(method_name, method_argc, bind_args)

func _fork(
	method_name: StringName,
	method_argc: int,
	bind_args: Array) -> void:

	var result: Variant
	match method_argc - bind_args.size():
		0:
			result = await _object.callv(method_name, bind_args)
		1:
			result = await _object.callv(method_name, bind_args + [release_cancel])
	if is_pending:
		release_complete(result)
