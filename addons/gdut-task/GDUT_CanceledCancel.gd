class_name GDUT_CanceledCancel extends Cancel

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

static func create(name := &"Cancel.canceled") -> Cancel:
	#
	# キャンセル作成
	#

	return new(name)

func get_name() -> StringName:
	return _name

func get_requested() -> bool:
	return true

#-------------------------------------------------------------------------------

var _name: StringName

func _init(name: StringName) -> void:
	_name = name
