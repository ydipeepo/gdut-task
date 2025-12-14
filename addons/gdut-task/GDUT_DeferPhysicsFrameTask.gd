class_name GDUT_DeferPhysicsFrameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_physics_frame") -> Task:
	#
	# 事前チェック
	#

	if not GDUT_Task.has_canonical():
		push_error(GDUT_Task.get_message(&"BAD_CANONICAL"))
		return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(name)

func finalize() -> void:
	GDUT_Task.disconnect_physics_frame(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.connect_physics_frame(release_complete)
