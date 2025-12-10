class_name GDUT_DeferPhysicsTask extends CustomTask

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Task.defer_physics") -> Task:
	#
	# タスク作成
	#

	return new(name)

func finalize() -> void:
	GDUT_Task.get_canonical().physics.disconnect(release_complete)

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	GDUT_Task.get_canonical().physics.connect(release_complete)
