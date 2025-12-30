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

	if GDUT_Task.canonical == null:
		GDUT_Task.print_error(&"ADDON_NOT_READY")
		request()
		return

	GDUT_Task.canonical.monitor_cancel(self)
