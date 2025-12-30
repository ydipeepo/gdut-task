class_name GDUT_ThenBoundMethodNameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	antecedent_task: Awaitable,
	object: Object,
	method_name: StringName,
	bind_args: Array,
	name := &"Task.then_bound_method_name") -> Task:

	#
	# 事前チェック
	#

	if bind_args.is_empty():
		return GDUT_ThenMethodNameTask.create(
			antecedent_task,
			object,
			method_name,
			name)
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
			if not GDUT_Task.validate_task_then_bound_method_name_0(
				object,
				method_name,
				bind_args):

				GDUT_Task.print_error(
					&"BAD_METHOD_ARGUMENT_SIGNATURE",
					method_name)
				return GDUT_CanceledTask.create(name)
		1:
			if not GDUT_Task.validate_task_then_bound_method_name_1(
				object,
				method_name,
				bind_args):

				GDUT_Task.print_error(
					&"BAD_METHOD_ARGUMENT_SIGNATURE",
					method_name)
				return GDUT_CanceledTask.create(name)
		2:
			if not GDUT_Task.validate_task_then_bound_method_name_2(
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
				method_argc)
			return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(
		antecedent_task,
		object,
		method_name,
		method_argc,
		bind_args,
		name)

func finalize() -> void:
	if _antecedent_task is CustomTask:
		_antecedent_task.temporary_release(self)
	_antecedent_task = null
	_object = null

#-------------------------------------------------------------------------------

var _antecedent_task: Awaitable
var _object: Object

func _init(
	antecedent_task: Awaitable,
	object: Object,
	method_name: StringName,
	method_argc: int,
	bind_args: Array,
	name: StringName) -> void:

	super(name)

	_antecedent_task = antecedent_task
	_object = object
	_fork(method_name, method_argc, bind_args)

func _fork(
	method_name: StringName,
	method_argc: int,
	bind_args: Array) -> void:

	var result: Variant = \
		await _antecedent_task.temporary_wait(self) \
		if _antecedent_task is CustomTask else \
		await _antecedent_task.wait(cascade_cancel)
	if is_pending:
		if _antecedent_task is Task:
			match _antecedent_task.get_state():
				STATE_COMPLETED:
					match method_argc - bind_args.size():
						0:
							result = await _object.callv(method_name, bind_args)
						1:
							result = await _object.callv(method_name, bind_args + [result])
						2:
							result = await _object.callv(method_name, bind_args + [result, release_cancel])
					if is_pending:
						release_complete(result)
				STATE_CANCELED:
					release_cancel()
				_:
					if not _antecedent_task is CustomTask or not _antecedent_task.is_pending:
						GDUT_Task.print_error(
							&"UNKNOWN_STATE_RETURNED_BY_ANTECEDENT",
							_antecedent_task)
					release_cancel()
		else:
			match method_argc - bind_args.size():
				0:
					result = await _object.callv(method_name, bind_args)
				1:
					result = await _object.callv(method_name, bind_args + [result])
				2:
					result = await _object.callv(method_name, bind_args + [result, release_cancel])
			if is_pending:
				release_complete(result)
