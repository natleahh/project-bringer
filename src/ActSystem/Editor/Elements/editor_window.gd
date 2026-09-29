class_name ActEditorWindow extends Control

const BIT_SCENE = preload("res://src/ActSystem/Editor/bit.tscn")
const LINK_SCENE = preload("res://src/ActSystem/Editor/link.tscn")

@onready var graph: ActGraph = ActGraph.new()

func _ready() -> void:
	graph.added.connect(_on_added_graph_element)

func _on_added_graph_element(graph_element: AGElement) -> void:
	if graph_element is AGBit:
			var bit: UIBit = BIT_SCENE.instantiate()
			bit.update_from_graph_element(graph_element)
			var connectors = bit.connection_container.get_children()
			add_child(bit)
			connectors.map(add_connector_signal)

	elif graph_element is AGLink:
			var link: UILink = LINK_SCENE.instantiate()
			link.update_from_graph_element(graph_element)
			add_child(link)

func add_connector_signal(graph_connector: UIConnector) -> void:
	graph_connector.connect_request.connect(_on_connect_request)

func _on_connect_request(a: AGConnector, b: AGConnector) -> void:
	graph.link_connectors(a, b)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is UIBit

func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.position = at_position
