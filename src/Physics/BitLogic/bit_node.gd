class_name BitNode extends RefCounted

signal graph_update
signal play_start
signal play_end

var _graph: ActGraph
var _data: BitData

var type: BitData.Type: 
	get: return _data.type
	
var limit: Dictionary[BitData.Type, int]:
	get: return _data.limit

var connectors: Array[BitConnector]:
	get: return _graph.bits[self].connectors

var selected: Array[BitConnector]:
	get: return connectors.filter(func (c): return c.link != null and c.link.selected)

var neighbours: Array[BitNode]:
	get: return (
		connectors
		.filter(func (c: BitConnector): return c.partner != null)
		.map(func (c): return c.partner.bit)
	)

func _init(graph: ActGraph, bit_data: BitData = null) -> void:
	_graph = graph
	_data = BitData.randomise() if bit_data == null else bit_data
