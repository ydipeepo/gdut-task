class_name GDUT_DeferIdleTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_idle") -> Task:
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
	GDUT_Task.disconnect_idle(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.connect_idle(release_complete)
