class_name UILink extends Control

var a: Vector2
var b: Vector2
@export var line: Line2D 

var graph_element: AGLink

func update_from_graph_element(ag_link: AGLink) -> void:
	graph_element = ag_link
	var _link_updateder: Callable = _on_bit_update.bind(ag_link)
	graph_element.a.updated.connect(_on_bit_update)
	graph_element.b.updated.connect(_on_bit_update)
	_on_bit_update(ag_link)

func _on_bit_update(ag_link: AGLink) -> void:
	a = ag_link.a.bit.data.editor_data.position * get_global_transform().inverse()
	b = ag_link.b.bit.data.editor_data.position * get_global_transform().inverse()
	line.points = [a, b]
