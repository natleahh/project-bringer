class_name BitUI extends RigidBody2D

signal connect_request(context: EditorContext)
signal play_request(connector: ConnectorUI)
signal moved

const CONNECTOR_UI = preload("res://src/Physics/BitUI/connector_ui.tscn")

var is_hover: bool 
var is_buffered: bool = false


@export var type_indicator: ColorRect
@export var player_indicator: ColorRect
@export var connectors: HBoxContainer

var bit: BitNode:
	set(val):
		bit = val
		global_position = data.spawn_position
		set_bit_signals(bit)
		refresh_data()

var data: BitData:
	get:
		return null if bit == null else bit._data
		
class EditorContext:
	var bit: BitUI
	var connector: ConnectorUI
	
	func _init(_bit: BitUI, _connector: ConnectorUI) -> void:
		bit = _bit
		connector = _connector

func _ready() -> void:
	body_entered.connect(func (_b): moved.emit())

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		moved.emit()

func refresh_data() -> void:
	type_indicator.color = BitData.get_type_color(bit.type)
	for connector_ui in connectors.get_children():
		connector_ui.refresh_data()

func add_connector_ui(bit_connector: BitConnector) -> void:
	var connector_ui = CONNECTOR_UI.instantiate()
	connector_ui.connector = bit_connector
	set_connector_signals(connector_ui)
	connectors.add_child(connector_ui)

func set_bit_signals(_bit: BitNode) -> void:
	_bit.play_start.connect(_on_play_start)
	_bit.play_end.connect(_on_play_end)
	_bit.graph_update.connect(refresh_data)

func set_connector_signals(connector_ui: ConnectorUI) -> void:
	connector_ui.connect_request.connect(_on_connnect_request.bind(connector_ui))
	connector_ui.play_request.connect(_on_play_request.bind(connector_ui))

func _on_connnect_request(connector_ui: ConnectorUI):
	connect_request.emit(EditorContext.new(self, connector_ui))

func _on_play_request(connector_ui: ConnectorUI):
	play_request.emit(connector_ui)

func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		is_hover = event.is_pressed()
		freeze = is_hover
		
func _on_play_start() -> void:
	player_indicator.visible = true

func _on_play_end() -> void:
	player_indicator.visible = false

func _process(_delta: float) -> void:
	if is_hover:
		global_transform.origin = get_global_mouse_position()
