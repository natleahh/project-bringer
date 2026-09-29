@abstract class_name UIGraphElement extends Control


func _on_removed_graph_element() -> void:
	queue_free()

func _on_updated_graph_element(ag_element: AGElement) -> void:
	update_from_graph_element(ag_element)

@abstract func update_from_graph_element(ag_element: AGElement) -> void
