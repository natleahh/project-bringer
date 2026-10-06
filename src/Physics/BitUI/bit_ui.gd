class_name BitUI extends StaticBody2D

signal connect_request
signal moved

var is_hover: bool 
var is_buffered: bool = false

@export var collision_shape_2d: CollisionShape2D

var bit: ActBit:
	set(val):
		bit = val
		global_position = data.spawn_position
		bit.graph_update.connect(_on_graph_update)

var data: BitData:
	get:
		return null if bit == null else bit._data

func buffer_reset() -> void:
	collision_shape_2d.debug_color = Color(0.0, 0.6, 0.702, 0.42)

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		is_hover = event.is_pressed()
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		collision_shape_2d.debug_color = Color(0.611, 0.532, 0.256, 0.42)
		connect_request.emit()

func _on_graph_update() -> void:
	# TODO Update displayed connection data
	pass

func _process(_delta: float) -> void:
	if is_hover:
		global_transform.origin = get_global_mouse_position()
		moved.emit()
