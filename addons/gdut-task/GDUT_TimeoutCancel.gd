class_name GDUT_TimeoutCancel extends CustomCancel

#-------------------------------------------------------------------------------
#	CONSTANTS
#-------------------------------------------------------------------------------

const MIN_TIMEOUT := 0.0

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(
	timeout_: float,
	ignore_pause: bool,
	ignore_time_scale: bool,
	name := &"Cancel.timeout") -> Cancel:

	#
	# 事前チェック
	#

	if timeout_ <= MIN_TIMEOUT:
		GDUT_Task.print_error(&"BAD_TIMEOUT")
		return GDUT_CanceledCancel.create(name)
	if timeout_ == MIN_TIMEOUT:
		return GDUT_CanceledCancel.create(name)

	#
	# キャンセル作成
	#

	return new(timeout_, ignore_pause, ignore_time_scale, name)

func get_name() -> StringName:
	return _name

func finalize() -> void:
	_timer.timeout.disconnect(request)
	_timer = null

#-------------------------------------------------------------------------------

var _timer: SceneTreeTimer

func _init(
	timeout_: float,
	ignore_pause: bool,
	ignore_time_scale: bool,
	name: StringName) -> void:

	super(name)

	_timer = GDUT_Task.create_timer(
		timeout_,
		ignore_pause,
		ignore_time_scale)
	_timer.timeout.connect(request)
