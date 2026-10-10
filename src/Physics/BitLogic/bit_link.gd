class_name BitLink extends RefCounted

signal removed
signal graph_updated

var _graph: ActGraph
var selected: bool:
	get:
		return _graph.links[self].selected

var left: BitConnector:
	get: return _graph.links[self].left

var right: BitConnector:
	get: return _graph.links[self].right
	

var type: BitData.Type

func _init(graph: ActGraph) -> void:
	_graph = graph
