class_name GDUT_DeferIdleTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_idle") -> Task:
	#
	# タスク作成
	#

	return new(name)

func finalize() -> void:
	GDUT_Task.get_canonical().idle.disconnect(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.get_canonical().idle.connect(release_complete)
