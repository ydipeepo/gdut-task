class_name GDUT_DeferPhysicsTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_physics") -> Task:
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
		GDUT_Task.canonical.physics.disconnect(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.canonical.physics.connect(release_complete)
