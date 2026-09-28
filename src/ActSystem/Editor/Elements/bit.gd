class_name EdBit extends EdElement

const CONNECTOR_SCENE = preload("res://src/ActSystem/Editor/connector.tscn")

@export var bit_button: TextureButton
@export var bit_texture: TextureRect
@export var connection_container: HBoxContainer

var graph_element: AGBit

var held: bool = false

func _ready() -> void:
	bit_button.button_down.connect(func (): held = true)
	bit_button.button_up.connect(func (): held = false)

func _process(delta: float) -> void:
	if held:
		global_position = get_global_mouse_position()

func update_from_graph_element(graph_bit: AGBit) -> void:
	graph_element = graph_bit
	bit_texture.texture = graph_bit.data.editor_data.texture

	graph_bit.connectors.map(add_connector)

func add_connector(graph_connector: AGConnector) -> void:
	var connector: EdConnector = CONNECTOR_SCENE.instantiate()
	connection_container.add_child(connector)
	connector.update_from_graph_element(graph_connector)
