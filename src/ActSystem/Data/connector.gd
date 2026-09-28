class_name ConnectorData extends Resource
var type: BitData.Type

static func randomise() -> ConnectorData:
	var connector_data: ConnectorData = ConnectorData.new()
	connector_data.type = BitData.Type.values()[randi() % BitData.Type.size()]
	return connector_data

static func randomise_array() -> Array[ConnectorData]:
	return range(0, randi_range(3, 5)).map(func (_i): return ConnectorData.randomise()) 
