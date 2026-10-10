class_name ActGraph extends RefCounted

signal new_node(node: BitNode)

class BitNodeFields:
	var connectors: Array = []
	
	func _init(graph: ActGraph, bit_data: BitData) -> void:
		connectors = BitConnector.from_bit_data(graph, bit_data)

class BitConnectorFields:
	var bit: BitNode
	var link: BitLink
	
	func _init(_bit: BitNode) -> void:
		bit = _bit

class BitLinkFields:
	var selected: bool
	var left: BitConnector
	var right: BitConnector
	
	func _init(_left: BitConnector, _right: BitConnector) -> void:
		left = _left
		right = _right

var bits: Dictionary[BitNode, BitNodeFields] = {}
var connectors: Dictionary[BitConnector, BitConnectorFields] = {}
var links: Dictionary[BitLink, BitLinkFields] = {}


func unlink_link(old: BitLink) -> void:
	if old == null:
		return
	var fields = links[old]
	
	# set to null in connectors
	connectors[fields.left].link = null
	connectors[fields.right].link = null

	# update connectors
	fields.left.graph_update.emit()
	fields.right.graph_update.emit()
	
	# remove from links
	links.erase(old)
	old.removed.emit()


func add_node(bit_data: BitData):
	var _node = BitNode.new(self, bit_data)
	bits[_node] = BitNodeFields.new(self, bit_data)
	for connector in bits[_node].connectors:
		connectors[connector] = BitConnectorFields.new(_node)
	new_node.emit(_node)

func get_adjacent(bit: BitNode) -> Array[BitNode]:
	var adjacent: Array = []
	for connector in bits[bit].connectors:
		var link = connectors[connector].link
		if link == null:
			continue
		var link_fields = links[link]
		if bit == link_fields.left:
			adjacent.append(link_fields.right)
		else:
			adjacent.append(link_fields.left)
	return adjacent
			

func can_connect(left: BitConnector, right: BitConnector) -> bool:
	 # Must not be on the same bit
	if left.bit == right.bit:
		return false
	# Must be on the same type
	if left.type != right.type: 
		return false
	# Must not already be connected (kind of trusting that nothing will slip through!)
	if right.bit.neighbours in left.bit.neighbours or right.bit in left.bit.neighbours:
		return false
	return true

func add_link(left: BitConnector, right: BitConnector) -> BitLink:
	## unlink old
	unlink_link(left.link)
	unlink_link(right.link)
	
	## creating and connecting new
	var new_link = BitLink.new(self)
	new_link.type = left.type
	connectors[left].link = new_link
	connectors[right].link = new_link
	links[new_link] = BitLinkFields.new(left, right)
	left.bit.graph_update.emit()
	right.bit.graph_update.emit()
	return new_link

func can_select_link(link: BitLink) -> bool:
	return (
		link.left.bit.selected.size() < 2
		and link.right.bit.selected.size() < 2
	)

func select_link(link: BitLink) -> void:
	if link.selected:
		links[link].selected = false
	elif not can_select_link(link):
		return
	else:
		links[link].selected = true
	link.graph_updated.emit()
