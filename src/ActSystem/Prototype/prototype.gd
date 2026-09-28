extends Node2D

@export var bit_data_container: VBoxContainer
@export var act_graph: ActGraph
@export var graph_repr_container: VBoxContainer
@export var player_options: VBoxContainer
@export var act_player: ActPlayer

var initial_data: Array

var current: PrototypeConnector

func _ready() -> void:
	initial_data = range(4).map(func (_i): return BitData.randomise())
	for each in initial_data:
		var _each = PrototypeBitDataButton.from_data(each)
		bit_data_container.add_child(_each)
		_each.pressed.connect(_on_data_button_pressed.bind(_each))

func _on_data_button_pressed(button: PrototypeBitDataButton) -> void:
	act_graph.add_bit(button.bit_data)
	button.queue_free()

func _on_connector_button_pressed() -> void:
	var connectors = get_tree().get_nodes_in_group("connectors")
	match connectors.filter(func (c): return c.button_pressed):
		[var a, var b]:
			if can_connect(a.graph_element, b.graph_element):
				act_graph.link_connectors(a.graph_element, b.graph_element)
			a.button_pressed = false
			b.button_pressed = false
			act_player.refresh()
		var too_many when too_many.size() > 2:
			for each in too_many:
				each.pressed = false

func can_connect(a: AGConnector, b: AGConnector) -> bool:
	if a.bit == b.bit:
		return false
	if a.data.type != b.data.type:
		return false
	if a.bit.connectors.any(func(c): return c.pair != null and c.pair.bit == b.bit):
		return false
	return true

func _on_act_graph_added(new_element: AGElement) -> void:
	if new_element is not AGBit:
		return
	var bit = HBoxContainer.new()
	var bit_button = Button.new()
	bit_button.icon = new_element.data.editor_data.texture
	bit.add_child(bit_button)
	bit_button.pressed.connect(_on_bit_button_press.bind(new_element))
	for connector in new_element.connectors:
		var pc = PrototypeConnector.new()
		pc.update_from_graph(connector)
		pc.graph_element = connector
		bit.add_child(pc)
		pc.add_to_group("connectors")
		pc.pressed.connect(_on_connector_button_pressed)
	graph_repr_container.add_child(bit)

func _on_bit_button_press(bit: AGBit) -> void:
	act_player.player_from_bit(bit)

func _on_act_player_new_options(options: Array) -> void:
	for child in player_options.get_children():
		child.queue_free()
	if act_player.current != null:
		var _current = Button.new()
		_current.text = "Current"
		_current.icon = act_player.current.bit.data.editor_data.texture
		player_options.add_child(_current)
	for option in options:
		var _option = Button.new()
		_option.text = "next"
		_option.icon = option.pair.bit.data.editor_data.texture
		_option.pressed.connect(_on_option_select.bind(option))
		player_options.add_child(_option)

func _on_option_select(connector: AGConnector) -> void:
	act_player.play_from_connector(connector)
