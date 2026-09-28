class_name ActPlayer extends Node
@export var act_graph: ActGraph

signal new_options(options: Array[AGConnector])

var current: AGConnector:
	set(val):
		current = val
		new_options.emit(current.next)

func player_from_bit(bit: AGBit) -> void:
	if current != null:
		return
	new_options.emit(bit.next)

func play_from_connector(connector: AGConnector) -> void:
	if current != null and connector not in current.next:
		return
	current = connector.pair
	new_options.emit(current.next)

func refresh() -> void:
	if current == null:
		return
	play_from_connector(current)
