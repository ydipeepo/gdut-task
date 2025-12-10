class_name GDUT_DeferIdleFrameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_idle_frame") -> Task:
	#
	# タスク作成
	#

	return new(name)

func finalize() -> void:
	GDUT_Task.get_canonical().idle_frame.disconnect(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.get_canonical().idle_frame.connect(release_complete)
