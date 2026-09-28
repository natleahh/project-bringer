class_name AGLink extends AGElement
var a: AGConnector
var b: AGConnector

func unlink() -> void:
	a.link = null
	b.link = null
	a.updated.emit(a)
	b.updated.emit(b)
	removed.emit(self)
	

static func from_connectors(connector_a: AGConnector, connector_b: AGConnector) -> AGLink:
	var new_link: AGLink = AGLink.new()
	new_link.a = connector_a
	new_link.b = connector_b
	return new_link
