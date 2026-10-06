class_name BitData extends RefCounted

enum Type {Clown, Satarist, Relater, Absurdist}

@export var type: Type
@export var limit: Dictionary[Type, int] = {}
var spawn_position: Vector2 = Vector2.ZERO

const COLOR_MAPPING: Array[Color] = [
	Color.GREEN,
	Color.RED,
	Color.BLUE,
	Color.YELLOW
]

static func randomise() -> BitData:
	var bd = BitData.new()
	var _types = Type.values() 
	bd.type = _types[randi() % Type.size()]
	for i in randi_range(3, 6):
		var each = _types[randi() % Type.size()]
		if each not in bd.limit:
			bd.limit[each] = 0
		bd.limit[each] += 1
	return bd

static func get_type_color(_type: Type) -> Color:
	return COLOR_MAPPING[_type]
