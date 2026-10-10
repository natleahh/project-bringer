class_name BitConnector extends RefCounted
var type: BitData.Type
var _graph: ActGraph

signal graph_update

var link: BitLink:
	get:
		return _graph.connectors[self].link
var bit: BitNode:
	get:
		return _graph.connectors[self].bit

var partner: BitConnector:
	get:
		if link == null:
			return
		elif link.left != self:
			return link.left
		else:
			return link.right

var siblings: Array[BitConnector]:
	get:
		return bit.connectors.filter(func (c): return c != self)

func _init(graph: ActGraph, _type: BitData.Type) -> void:
	type = _type
	_graph = graph

static func from_bit_data(graph: ActGraph, bit_data: BitData) -> Array:
	var connectors = []
	for _type in bit_data.limit:
		for _i in bit_data.limit[_type]:
			connectors.append(BitConnector.new(graph, _type))
	return connectors

func has_selected() -> bool:
	return link != null and link.selected
