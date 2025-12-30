class_name GDUT_DeferIdleFrameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_idle_frame") -> Task:
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
		GDUT_Task.canonical.idle_frame.disconnect(release_complete)

#-------------------------------------------------------------------------------

var _tree: SceneTree

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.canonical.idle_frame.connect(release_complete)
