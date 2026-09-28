class_name AGConnector extends AGElement
var data: ConnectorData
var bit: AGBit
var link: AGLink

var pair: AGConnector:
	get:
		return null if link == null else (link.a if link.a != self else link.b)
 
var next: Array:
	get:
		return bit.connectors.filter(_has_next)

func _has_next(connector: AGConnector) -> bool:
	return connector != self and connector.pair != null

static func from_data(connector_data: ConnectorData, parent_bit: AGBit) -> AGConnector:
	var connector = AGConnector.new()
	connector.data = connector_data
	connector.bit = parent_bit
	return connector

func update_link(new_link: AGLink) -> void:
	link = new_link
	updated.emit(self)
	

func unlink() -> void:
	link.unlink()
	
