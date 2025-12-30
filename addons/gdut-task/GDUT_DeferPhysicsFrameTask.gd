class_name GDUT_DeferPhysicsFrameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_physics_frame") -> Task:
	#
	# 事前チェック
	#

	if GDUT_Task.canonical == null:
		GDUT_Task.print_error(&"ADDON_NOT_READY")
		return GDUT_CanceledTask.create(name)

	#
	# タスク作成
	#

	return new(name)

func finalize() -> void:
	if GDUT_Task.canonical != null:
		GDUT_Task.canonical.physics_frame.disconnect(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.canonical.physics_frame.connect(release_complete)
