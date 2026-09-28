class_name ActEditorWindow extends Control

const BIT_SCENE = preload("res://src/ActSystem/Editor/bit.tscn")

@onready var graph: ActGraph = ActGraph.new()
var editor_ref: Dictionary[AGElement, EdElement] = {}

func _ready() -> void:
	graph.added.connect(_on_added_graph_element)
	graph.removed.connect(_on_removed_graph_element)

func _on_added_graph_element(graph_element: AGElement) -> void:
	var new_elements: Array[EdElement] = []
	if graph_element is AGBit:
			var bit: EdBit = BIT_SCENE.instantiate()
			bit.update_from_graph_element(graph_element)
			var connectors = bit.connection_container.get_children()
			add_child(bit)
			connectors.map(add_connector_signal)
			new_elements.append(bit)
			new_elements.append_array(connectors)

	elif graph_element is AGLink:
			var link: EdLink = EdLink.from_connectors(
				editor_ref[graph_element.a.bit],
				editor_ref[graph_element.b.bit],
			)
			link.graph_connector = graph_element
			add_child(link)
	for element in new_elements:
		editor_ref[element.graph_element] = element

func add_connector_signal(graph_connector: EdConnector) -> void:
	graph_connector.connect_request.connect(_on_connect_request)

func _on_removed_graph_element(graph_element: AGElement) -> void:
	editor_ref[graph_element].queue_free()

func _on_connect_request(a: EdConnector, b: EdConnector) -> void:
	graph.link_connectors(a.graph_element, b.graph_element)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is EdBit 

func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.position = at_position
