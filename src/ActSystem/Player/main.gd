class_name ActPlayer extends Node

signal current_changed
var _current: ActGraph.AGConnector
var current: ActGraph.AGConnector:
	get:
		return _current
	set(val):
		_current = val
		current_changed.emit()

var current_bit: ActGraph.AGBit:
	get:
		return _current.bit

var current_link: ActGraph.AGLink:
	get:
		return _current.link

var next: Array[ActGraph.AGConnector]:
	get:
		return _current.bit.connectors.filter(_is_current)

func _is_current(connector: ActGraph.AGConnector) -> bool:
	return connector == current

func play(next_connector: ActGraph.AGConnector) -> bool:
	if next_connector not in current.bit.connectors:
		return false
	elif next_connector == current:
		return false
	else:
		_current = next_connector
		return true
