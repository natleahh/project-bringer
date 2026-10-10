class_name ConnectorUI extends ColorRect

signal connect_request
signal play_request
var connector: BitConnector:
	set(c):
		connector = c
		connector.graph_update.connect(refresh_data)
		refresh_data()
@export var selection_indicator: TextureRect
@export var connected_indicator: ColorRect

func refresh_data() -> void:
	color = BitData.get_type_color(connector.type)
	connected_indicator.visible = connector.link != null

func _gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not event.is_pressed():
		return
	match event.button_index:
		MOUSE_BUTTON_RIGHT:
			selection_indicator.visible = true
			connect_request.emit()
		MOUSE_BUTTON_MIDDLE:
			play_request.emit()


func buffer_reset() -> void:
	selection_indicator.visible = false
