class_name GDUT_LoadTask extends CustomTask

#-------------------------------------------------------------------------------
#	CLASSES
#-------------------------------------------------------------------------------

class Worker extends Node:

	signal completed(resource: Variant)
	signal aborted

	var resource_path: String
	var resource_type: StringName

	func _init() -> void:
		name = "Worker_LoadTask-%s" % String.num_uint64(get_instance_id(), 16, true)

	func _process(delta: float) -> void:
		var status := ResourceLoader.load_threaded_get_status(resource_path)
		match status:
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				if is_inside_tree():
					GDUT_Task.error(
						&"TASK_RESOURCE_LOADER_INVALID_RESOURCE",
						resource_path,
						resource_type)
					get_parent().remove_child(self)
				aborted.emit()
				free()
			#ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			#	pass
			ResourceLoader.THREAD_LOAD_FAILED:
				if is_inside_tree():
					GDUT_Task.error(
						&"TASK_RESOURCE_LOADER_FAILED",
						resource_path,
						resource_type)
					get_parent().remove_child(self)
				aborted.emit()
				free()
			ResourceLoader.THREAD_LOAD_LOADED:
				var resource := ResourceLoader.load_threaded_get(resource_path)
				if is_inside_tree():
					get_parent().remove_child(self)
				completed.emit(resource)
				free()

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	resource_path: String,
	resource_type: StringName,
	cache_mode: ResourceLoader.CacheMode,
	name := &"Task.load") -> Task:

	#
	# 事前チェック
	#

	var worker: Worker
	for node: Node in GDUT_Task.get_canonical().get_children():
		worker = node as Worker
		if worker != null:
			if \
				worker.resource_path == resource_path and \
				worker.resource_type == resource_type:
				break
			worker = null
	if worker == null:
		var error := ResourceLoader.load_threaded_request(
			resource_path,
			resource_type,
			true,
			cache_mode)
		if error == OK:
			worker = Worker.new()
			worker.resource_path = resource_path
			worker.resource_type = resource_type
			GDUT_Task.get_canonical().add_child(worker)
	if worker == null:
		return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(worker, name)

func finalize() -> void:
	_worker.completed.disconnect(release_complete)
	_worker.aborted.disconnect(release_cancel)
	_worker = null

#-------------------------------------------------------------------------------

var _worker: Worker

func _init(worker: Worker, name: StringName) -> void:
	super(name)

	_worker = worker
	_worker.completed.connect(release_complete)
	_worker.aborted.connect(release_cancel)
