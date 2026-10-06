class_name ActEditor extends Node2D

var connection_buffer: Array[BitUI] = []
@onready var graph: ActGraph = ActGraph.new()
@export var connections: Node
@export var bits: Node

const BIT_UI = preload("res://src/Physics/BitUI/bit_ui.tscn")

func _ready() -> void:
	set_graph_signals()

## Set Event Listeners
func set_graph_signals() -> void:
	graph.new_node.connect(_on_new_node)

func set_bit_signals(bit: BitUI) -> void:
	bit.connect_request.connect(_on_connect_request.bind(bit))

## Event Listeners
func _on_new_node(bit: ActBit) -> void:
	var bit_ui: BitUI = BIT_UI.instantiate()
	bit_ui.bit = bit
	bits.add_child(bit_ui)
	set_bit_signals(bit_ui)

func _on_connect_request(bit_node: BitUI) -> void:
	connection_buffer.append(bit_node)
	if connection_buffer.size() == 1:
		return
	elif connection_buffer.size() == 2 and graph.connect_nodes(connection_buffer[0].bit, connection_buffer[1].bit):
		var link_ui = ActLink.new(connection_buffer[0], connection_buffer[1])
		connections.add_child(link_ui)
	for each in connection_buffer:
		each.buffer_reset()
	connection_buffer = []

func _on_button_pressed() -> void:
	var data = BitData.randomise()
	data.spawn_position = get_viewport_rect().size / 2
	graph.add_node(data)
