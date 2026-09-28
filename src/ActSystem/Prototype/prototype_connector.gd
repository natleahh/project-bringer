class_name PrototypeConnector extends Button

var graph_element: AGConnector:
	set(element):
		element.updated.connect(update_from_graph)
		graph_element = element

static func from_graph_element(graph_connector: AGConnector) -> PrototypeConnector:
	var _connector = PrototypeConnector.new()
	_connector.graph_element = graph_connector
	_connector.update_from_graph(graph_connector)
	return _connector

func _init() -> void:
	toggle_mode = true

func update_from_graph(element: AGConnector):
	text = BitData.Type.keys()[element.data.type] 
	icon = null if element.pair == null else element.pair.bit.data.editor_data.texture
