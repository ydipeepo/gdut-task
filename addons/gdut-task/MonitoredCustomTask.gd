## Represents an extension point for implementing custom [Task]s.
## If there is a possibility of deadlock, derive from [MonitoredCustomTask].
@abstract
class_name MonitoredCustomTask extends CustomTask

#-------------------------------------------------------------------------------
#	PROPERTIES
#-------------------------------------------------------------------------------

## Returns whether this [MonitoredCustomTask] is deadlocked.
var is_indefinitely_pending: bool:
	get = get_indefinitely_pending

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

## Returns whether this [MonitoredCustomTask] is deadlocked.[br]
## [br]
## This method is called periodically until this [MonitoredCustomTask] is settled (either completed or canceled).
## It must be implemented to return [code]true[/code] when it's in a deadlock.
@abstract
func get_indefinitely_pending() -> bool

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	if not GDUT_Task.has_canonical():
		push_error(GDUT_Task.get_message(&"BAD_CANONICAL"))
		release_cancel()
		return

	GDUT_Task.monitor_task(self)
