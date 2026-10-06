class_name ActLink extends Node2D

enum State {
	Default,
	Active,
	Selected
}

var state: State = State.Default

@export var selected_color: Color = Color.RED
@export var default_color: Color = Color.WHITE
@export var active_color: Color = Color.GREEN

@export var start: BitUI:
	set(val):
		val.moved.connect(queue_redraw)
		start = val
	
@export var end: BitUI:
	set(val):
		val.moved.connect(queue_redraw)
		end = val

func _init(_start: Node2D, _end: Node2D) -> void:
	start = _start
	end = _end

func _draw() -> void:
	if start == null or end == null:
		return
	draw_line(
		to_local(start.global_position),
		to_local(end.global_position), get_line_color())
	
func get_line_color() -> Color:
	match state as State:
		State.Active:
			return active_color
		State.Selected:
			return selected_color
	return default_color
