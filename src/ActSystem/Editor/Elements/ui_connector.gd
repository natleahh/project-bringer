class_name UIConnector extends Control
signal connect_request(a: AGConnector, b: AGConnector)

const COLOUR_MAP: Dictionary[BitData.Type, Texture2D] = {
	BitData.Type.Clown: preload("res://PNG/Pixel/Style 8/emote_heart.png"),
	BitData.Type.Relater: preload("res://PNG/Pixel/Style 8/emote_cash.png"),
	BitData.Type.Satarist: preload("res://PNG/Pixel/Style 8/emote_idea.png"),
	BitData.Type.Absurdist: preload("res://PNG/Pixel/Style 8/emote_swirl.png"),
}
@export var texture_rect: TextureRect

var graph_element: AGConnector

func update_from_graph_element(graph_connector: AGElement) -> void:
	graph_element = graph_connector
	texture_rect.texture = COLOUR_MAP[graph_connector.data.type]

func _get_drag_data(_at_position: Vector2) -> Variant:
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is UIConnector

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	connect_request.emit(graph_element, data.graph_element)
