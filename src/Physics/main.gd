class_name ActEditor extends Node2D

var connection_buffer: Array[BitUI.EditorContext] = []
@onready var graph: ActGraph = ActGraph.new()
@export var act_player: ActPlayer
@export var connections: Node
@export var bits: Node

const BIT_UI = preload("res://src/Physics/BitUI/bit_ui.tscn")
const LINK_UI = preload("res://src/Physics/BitUI/link_ui.tscn")

func _ready() -> void:
	act_player.graph = graph
	set_graph_signals()
	set_player_signals()

## Set Event Listeners
func set_graph_signals() -> void:
	graph.new_node.connect(_on_new_node)

func set_bit_signals(bit_ui: BitUI) -> void:
	bit_ui.connect_request.connect(_on_connect_request)
	bit_ui.play_request.connect(_on_play_request)

func set_link_signals(link_ui: LinkUI) -> void:
	link_ui.selected_request.connect(_on_selected_request.bind(link_ui))

func set_player_signals() -> void:
	act_player.tock.connect(_on_player_tock)
	#act_player.request_selection.connect(_on_next_selection_request)

## Event Listeners
func _on_new_node(bit: BitNode) -> void:
	var bit_ui: BitUI = BIT_UI.instantiate()
	bit_ui.bit = bit
	for connector in graph.bits[bit].connectors:
		bit_ui.add_connector_ui(connector)
	bits.add_child(bit_ui)
	set_bit_signals(bit_ui)

func _on_connect_request(context: BitUI.EditorContext) -> void:
	connection_buffer.append(context)
	if connection_buffer.size() == 1:
		return
	elif connection_buffer.size() == 2 and graph.can_connect(
		connection_buffer[0].connector.connector,
		connection_buffer[1].connector.connector
	):
		var link_ui = LINK_UI.instantiate()
		link_ui.link = graph.add_link(
			connection_buffer[0].connector.connector,
			connection_buffer[1].connector.connector
		)
		link_ui.start = connection_buffer[0].bit
		link_ui.end = connection_buffer[1].bit
		connections.add_child(link_ui)
		set_link_signals(link_ui)
	for each in connection_buffer:
		each.connector.buffer_reset()
	connection_buffer = []

func _on_selected_request(link_ui: LinkUI):
	graph.select_link(link_ui.link)
	act_player._tick()

func _on_play_request(connector_ui: ConnectorUI):
	act_player.play_from(connector_ui.connector.bit)

func _on_player_tock():
	var play_history = []

func _on_next_selection_request() -> void:
	act_player.next.map(func (b): b.request_start.emit(act_player.current))
	

func _on_button_pressed() -> void:
	var data = BitData.randomise()
	data.spawn_position = get_viewport_rect().size / 2
	graph.add_node(data)
