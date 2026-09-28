class_name ActGraph extends Node

signal added(new_element: AGElement)
signal removed(new_element: AGElement)

var graph: Array[AGBit] = []

func link_connectors(a: AGConnector, b: AGConnector) -> void:
	# remove old links
	unlink_connector(a)
	unlink_connector(b)
	
	# add new
	var new_link: AGLink = AGLink.from_connectors(a, b)
	a.link = new_link
	b.link = new_link
	a.updated.emit(a)
	b.updated.emit(b)
	added.emit(new_link)

func unlink_connector(connector: AGConnector) -> void:
	if connector.link == null:
		return
	var pair = connector.pair
	pair.link = null
	pair.updated.emit(pair)
	
	# Queue link for removal
	connector.link.removed.emit(connector)
	
	# Unlink self
	connector.link = null

func unlink_link(old_link: AGLink) -> void:
	removed.emit(old_link)

func add_bit(data: BitData) -> void:
	var new_bit = AGBit.from_data(data)
	graph.append(new_bit)
	added.emit(new_bit)

func remove_bit(old_bit: AGBit) -> void:
	_remove_element(old_bit)
	removed.emit()

func _remove_element(element: AGElement) -> bool:
	if element is AGConnector:
		return false
	for i in graph.size():
		if graph[i] != element:
			continue
		graph.remove_at(i)
		return true
	return false
