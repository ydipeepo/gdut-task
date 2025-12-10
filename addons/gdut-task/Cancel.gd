## It is a class that holds a state indicating whether cancellation has been requested,
## and is used to request the interruption of the [Task].
@abstract
class_name Cancel

#-------------------------------------------------------------------------------
#	SIGNALS
#-------------------------------------------------------------------------------

## Emits when cancellation is requested.
signal requested

#-------------------------------------------------------------------------------
#	PROPERTIES
#-------------------------------------------------------------------------------

## Returns whether this [Cancel] is requesting cancellation.
var is_requested: bool:
	get = get_requested

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

## Creates a [Cancel] that's requested.
static func canceled() -> Cancel:
	return GDUT_CanceledCancel.create()

## Returns an [Array] containing [Cancel] and [Callable] to request it.
## [codeblock]
## var opers = Cancel.with_operators()
## # opers[0] is Cancel
## # opers[1] is Callable for request
##
## # ...
##
## opers[1].call()
##
## # ...
## [/codeblock]
static func with_operators() -> Array:
	return GDUT_WithOperatorsCancel.create()

## Creates a [Cancel] from the specified signal defined on an object.
## [codeblock]
## signal s
##
## var c = Cancel.from_signal_name(self, &"s")
## assert(not c.is_requested)
## s.emit()
## assert(c.is_requested)
## [/codeblock]
## [b]Note:[/b] This [Task] holds a strong reference to the [param object] until it is requested.
static func from_signal_name(
	object: Object,
	signal_name := &"completed") -> Cancel:

	return GDUT_FromSignalNameCancel.create(object, signal_name)

## Creates a [Cancel] from the specified signal.
## [codeblock]
## signal s
##
## var c = Cancel.from_signal(s)
## assert(not c.is_requested)
## s.emit()
## assert(c.is_requested)
## [/codeblock]
static func from_signal(signal_: Signal) -> Cancel:
	return GDUT_FromSignalCancel.create(signal_)

## Creates a [Cancel] from the specified INIT.
## It is another interface of [method from], not a vararg [param init_array].
static func from_v(init: Array) -> Cancel:
	return GDUT_FromCancel.create(init)

## Creates a [Cancel] from the specified INIT.[br]
## [br]
## [param init] is normalized according to the following rules:
## [codeblock]
## var c
##
## #
## # The following conversions are supported.
## # Lower items have lower priority.
## #
##
## # Dispatches from_signal_name,
## # if a method is defined.
## c = Cancel.from_v([Object, String|StringName])
##
## # Dispatches from_signal,
## # if a signal is defined.
## c = Cancel.from_v([Signal])
##
## # Wraps specified Cancel.
## c = Cancel.from_v([Cancel])
##
## # Dispatches from_signal_name,
## # if a 'completed' signal is defined.
## c = Cancel.from_v([Object])
##
## # Dispatches from_signal,
## # if a signal is defined.
## c = Cancel.from_v(Signal)
##
## # Wraps specified Cancel.
## c = Cancel.from_v(Cancel)
##
## # Dispatches from_signal_name,
## # if a 'completed' signal is defined.
## c = Cancel.from_v(Object)
##
## # Dispatches canceled.
## c = Cancel.from_v()
## [/codeblock]
static func from(...init: Array) -> Cancel:
	return from_v(init)

## Creates a [Cancel] that requests upon timeout.
static func timeout(
	timeout_: float,
	ignore_pause := false,
	ignore_time_scale := false) -> Cancel:

	return GDUT_TimeoutCancel.create(timeout_, ignore_pause, ignore_time_scale)

## Creates a [Cancel] that requests at the end of this processing or physics frame.
static func deferred() -> Cancel:
	return GDUT_DeferredCancel.create()

## Creates a [Cancel] that requests when any INIT requests.
## It is another interface of [method merged], not a vararg [param init_array].
static func merged_v(init_array: Array) -> Cancel:
	return GDUT_MergedCancel.create(init_array)

## Creates a [Cancel] that requests when any INIT requests.
## [codeblock]
## var c = Cancel.merged(
##     Cancel.canceled(),
##     Cancel.deferred(),
##     Cancel.timeout(1.0))
## [/codeblock]
## [b]Note:[/b] INIT (each component of [param init_array]) will be normalized according to the [method from] rule.
static func merged(...init_array: Array) -> Cancel:
	return merged_v(init_array)

## Returns the name of this [Cancel].
@abstract
func get_name() -> StringName

## Returns whether this [Cancel] is requesting cancellation.[br]
## [br]
## [b]Note:[/b] You can use the [member is_requested] properties for the same purpose.
@abstract
func get_requested() -> bool

#-------------------------------------------------------------------------------

func _to_string() -> String:
	var prefix: String = GDUT_Task.get_canonical().translate(
		&"CANCEL_STATE_REQUESTED"
		if is_requested else
		&"CANCEL_STATE_PENDING")
	return &"%s<%s#%d>" % [prefix, get_name(), get_instance_id()]
