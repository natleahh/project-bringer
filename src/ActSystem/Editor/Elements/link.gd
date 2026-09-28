class_name EdLink extends EdElement

@export var a: EdBit
@export var b: EdBit
var local_position_a: Vector2:
	get:
		return  get_global_transform().inverse() * a.get_global_rect().get_center()

var local_position_b: Vector2:
	get:
		return get_global_transform().inverse() * b.get_global_rect().get_center()

var graph_connector: AGLink

static func from_connectors(_a: EdBit, _b: EdBit) -> EdLink:
	var link = EdLink.new()
	link.a = _a
	link.b = _b
	_a.item_rect_changed.connect(link.queue_redraw)
	_b.item_rect_changed.connect(link.queue_redraw)
	return link 

func _draw() -> void:
	draw_multiline([a.global_position, b.global_position], Color("white"))
