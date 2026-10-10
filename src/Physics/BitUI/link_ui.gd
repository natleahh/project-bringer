class_name LinkUI extends Control

signal selected_request

var link: BitLink:
	set(l):
		link = l
		if link != null:
			link.removed.connect(queue_free)
			link.graph_updated.connect(queue_redraw)

@export var start: BitUI:
	set(val):
		val.moved.connect(queue_redraw)
		start = val
	
@export var end: BitUI:
	set(val):
		val.moved.connect(queue_redraw)
		end = val

var points: PackedVector2Array:
	get: return [start.global_position, end.global_position]

var width
	

func _gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not event.is_pressed():
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		selected_request.emit()

func _has_point(point: Vector2) -> bool:
	if start == null or end == null:
		return false
	var closest = Geometry2D.get_closest_point_to_segment(
		point,
		start.global_position,
		end.global_position,
	)
	
	return (closest - point).length_squared() < 5 ** 2
	

func _draw() -> void:
	if start == null or end == null:
		return
	if link.selected:
		draw_line(
			start.global_position,
			end.global_position,
			Color.WHITE,
			6
		)
	draw_line(
		start.global_position,
		end.global_position,
		BitData.get_type_color(link.type),
		3
	)
