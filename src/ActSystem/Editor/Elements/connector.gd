class_name EdConnector extends EdElement
signal connect_request(a: EdConnector, b: EdConnector)

const COLOUR_MAP: Dictionary[BitData.Type, Texture2D] = {
	BitData.Type.Clown: preload("res://PNG/Pixel/Style 8/emote_heart.png"),
	BitData.Type.Relater: preload("res://PNG/Pixel/Style 8/emote_cash.png"),
	BitData.Type.Satarist: preload("res://PNG/Pixel/Style 8/emote_idea.png"),
	BitData.Type.Absurdist: preload("res://PNG/Pixel/Style 8/emote_swirl.png"),
}
var graph_element: AGConnector

@export var texture_rect: TextureRect

func update_from_graph_element(graph_connector: AGConnector) -> void:
	graph_element = graph_connector
	texture_rect.texture = COLOUR_MAP[graph_connector.data.type]

func _get_drag_data(_at_position: Vector2) -> Variant:
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is EdConnector

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	connect_request.emit(self, data as EdConnector)
