class_name UIBit extends Control

const CONNECTOR = preload("res://src/ActSystem/Editor/connector.tscn")

@export var bit_button: TextureButton
@export var bit_texture: TextureRect
@export var connection_container: HBoxContainer

var graph_element: AGBit

var held: bool = false

func _init() -> void:
	item_rect_changed.connect(_on_movement)


func _process(_delta: float) -> void:
	if bit_button.button_pressed:
		global_position = get_global_mouse_position()
		

func _on_movement() -> void:
	graph_element.data.editor_data.position = bit_texture.get_global_rect().get_center()
	graph_element.updated.emit(graph_element)
	
func update_from_graph_element(graph_bit: AGBit) -> void:
	graph_element = graph_bit
	bit_texture.texture = graph_bit.data.editor_data.texture
	
	graph_bit.connectors.map(add_connector)

func add_connector(graph_connector: AGConnector) -> void:
	var connector: UIConnector = CONNECTOR.instantiate()
	connection_container.add_child(connector)
	connector.update_from_graph_element(graph_connector)
