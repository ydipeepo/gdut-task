class_name GDUT_DeferPhysicsFrameTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_physics_frame") -> Task:
	#
	# タスク作成
	#

	return new(name)

func finalize() -> void:
	GDUT_Task.get_canonical().physics_frame.disconnect(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.get_canonical().physics_frame.connect(release_complete)
