class_name AGBit extends AGElement

var data: BitData
var connectors: Array = []
var connector_count: Dictionary[BitData.Type, int]:
	get = get_connector_count

var next: Array[AGConnector]:
	get:
		var _cs: Array[AGConnector] = []
		for c in connectors:
			if c.pair == null:
				continue
			_cs.append(c)
		return _cs

static func from_data(bit_data: BitData) -> AGBit:
	var bit = AGBit.new()
	bit.data = bit_data
	bit.connectors = bit_data.connector_data.map(func(each): return AGConnector.from_data(each, bit))
	return bit

static func has_pair(c: ConnectorData) -> bool:
	return c.pair != null

func get_connector_count() -> Dictionary[BitData.Type, int]:
	var _d = data.get_connector_dict()
	for c in connectors:
		if c.data.type != null:
			continue
		_d[c.data.type] -= 1
	return _d
