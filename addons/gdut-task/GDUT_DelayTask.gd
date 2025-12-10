class_name GDUT_DelayTask extends CustomTask

#-------------------------------------------------------------------------------
#	CONSTANTS
#-------------------------------------------------------------------------------

const MIN_TIMEOUT := 0.0

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	timeout: float,
	ignore_pause: bool,
	ignore_time_scale: bool,
	name := &"Task.delay") -> Task:

	#
	# 事前チェック
	#

	if timeout < MIN_TIMEOUT:
		GDUT_Task.error(&"INVALID_TIMEOUT")
		return GDUT_CanceledTask.create(name)
	if timeout == MIN_TIMEOUT:
		return GDUT_CompletedTask.create(MIN_TIMEOUT, name)

	#
	# タスク作成
	#

	return new(timeout, ignore_pause, ignore_time_scale, name)

func finalize() -> void:
	_timer.timeout.disconnect(release_complete)
	_timer = null

#-------------------------------------------------------------------------------

var _timer: SceneTreeTimer

func _init(
	timeout: float,
	ignore_pause: bool,
	ignore_time_scale: bool,
	name: StringName) -> void:

	super(name)

	_timer = GDUT_Task.get_canonical().create_timer(
		timeout,
		ignore_pause,
		ignore_time_scale)
	_timer.timeout.connect(release_complete.bind(timeout))
