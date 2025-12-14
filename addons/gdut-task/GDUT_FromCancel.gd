class_name GDUT_FromCancel extends CustomCancel

#------------------------------------------------------------------------------
#	METHODS
#------------------------------------------------------------------------------

static func create(init: Variant, name := &"Cancel.from") -> Cancel:
	if init is Array:
		match init.size():
			3 when init[0] is Object and (init[1] is String or init[1] is StringName):
				if init[0].has_signal(init[1]):
					if init[2] is Array:
						return GDUT_FromFilteredSignalNameCancel.create(
							init[0],
							init[1],
							init[2],
							name)
			2 when init[0] is Object and (init[1] is String or init[1] is StringName):
				return GDUT_FromSignalNameCancel.create(init[0], init[1], name)
			2 when init[0] is Signal:
				if init[1] is Array:
					return GDUT_FromFilteredSignalCancel.create(
						init[0],
						init[1],
						name)
			1 when init[0] is Signal:
				return GDUT_FromSignalCancel.create(init[0], name)
			1 when init[0] is Object:
				if init[0] is Cancel:
					return \
						GDUT_CanceledCancel.create(name) \
						if init[0].is_requested else \
						new(init[0], name)
				else:
					return GDUT_FromSignalNameCancel.create(
						init[0],
						&"completed",
						name)
	if init is Signal:
		return GDUT_FromSignalCancel.create(init, name)
	if init is Object:
		if init is Cancel:
			return \
				GDUT_CanceledCancel.create(name) \
				if init.is_requested else \
				new(init, name)
		else:
			return GDUT_FromSignalNameCancel.create(init, &"completed", name)

	push_error(GDUT_Task.get_message(&"BAD_INIT"))
	return GDUT_CanceledCancel.create(name)

func finalize() -> void:
	if _cancel.requested.is_connected(request):
		_cancel.requested.disconnect(request)
	_cancel = null

#------------------------------------------------------------------------------

var _cancel: Cancel

func _init(cancel: Cancel, name: StringName) -> void:
	super(name)

	_cancel = cancel
	_cancel.requested.connect(request)
