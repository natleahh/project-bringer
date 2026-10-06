class_name ActBit extends RefCounted

signal graph_update

var _graph: ActGraph
var _data: BitData

var type: BitData.Type: 
	get: return _data.type
	
var limit: Dictionary[BitData.Type, int]:
	get: return _data.limit

var connections: Array[ActBit]:
	get: return _graph.data[self]
	
var current:  Dictionary[BitData.Type, int]:
	get: 
		var _current = limit.duplicate()
		for each in connections:
			_current[each.type] -= 1
		return _current

func _init(graph: ActGraph, bit_data: BitData = null) -> void:
	_graph = graph
	_data = BitData.randomise()  if bit_data == null else bit_data


func can_connect(other: ActBit) -> bool:
	return other not in connections and current.get(other.type, 0) > 0
