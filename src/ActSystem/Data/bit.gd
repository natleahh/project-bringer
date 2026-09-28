class_name BitData extends Resource

enum Type {Clown, Absurdist, Satarist, Relater}

var connector_data: Array
var editor_data: EditorData


static func randomise() -> BitData:
	var bit := BitData.new()
	bit.connector_data = ConnectorData.randomise_array()
	bit.editor_data = EditorData.randomise()
	return bit

func get_connector_dict() -> Dictionary[BitData.Type, int]:
	var _dict : Dictionary[BitData.Type, int] = {}
	for c in connector_data:
		if c.type not in _dict:
			_dict[c.type] = 1
		else:
			_dict[c.type] += 1
	return _dict
