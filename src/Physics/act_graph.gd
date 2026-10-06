class_name ActGraph extends RefCounted

signal new_node

var data: Dictionary[ActBit, Array] = {}

func _init(_data = null) -> void:
	data = data if _data  == null else _data

func add_node(bit_data: BitData):
	var _node = ActBit.new(self, bit_data)
	data[_node] = []
	new_node.emit(_node)

func connect_nodes(left: ActBit, right: ActBit) -> bool:
	if not left.can_connect(right) or not right.can_connect(left):
		return false
	data[left].append(right)
	data[right].append(left)
	left.graph_update.emit()
	right.graph_update.emit()
	return true
