## Represents an extension point for implementing custom [Cancel]s.
## If there is a possibility of deadlock, derive from [MonitoredCustomCancel].
@abstract
class_name MonitoredCustomCancel extends CustomCancel

#-------------------------------------------------------------------------------
#	PROPERTIES
#-------------------------------------------------------------------------------

## Returns whether this [MonitoredCustomCancel] is deadlocked.
var is_indefinitely_pending: bool:
	get = get_indefinitely_pending

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

## Returns whether this [MonitoredCustomCancel] is deadlocked.[br]
## [br]
## This method is called periodically until cancellation is requested on this [MonitoredCustomCancel].
## It must be implemented to return [code]true[/code] when it's in a deadlock.
@abstract
func get_indefinitely_pending() -> bool

#-------------------------------------------------------------------------------

func _init(name: StringName) -> void:
	super(name)

	if not GDUT_Task.has_canonical():
		push_error(GDUT_Task.get_message(&"BAD_CANONICAL"))
		request()
		return

	GDUT_Task.monitor_cancel(self)
