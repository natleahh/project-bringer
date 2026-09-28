class_name PrototypeBitDataButton extends Button

var bit_data: BitData:
	get:
		return bit_data if graph_element == null else graph_element.data
var graph_element: AGBit

static func from_element(element: AGBit) -> PrototypeBitDataButton:
	var _button = PrototypeBitDataButton.new()
	_button.graph_element = element
	_button.text = str(to_readable_type_summary(element.connector_count))
	return _button

static func from_data(data: BitData) -> PrototypeBitDataButton:
	var _button = PrototypeBitDataButton.new()
	_button.bit_data = data
	_button.text = str(to_readable_type_summary(data.get_connector_dict()))
	return _button

static func to_readable_type_summary(summary: Dictionary[BitData.Type, int]) -> Dictionary[StringName, int]:
	var _d: Dictionary = {}
	for k in summary:
		_d[BitData.Type.keys()[k]] = summary[k]
	return _d
