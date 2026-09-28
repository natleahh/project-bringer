extends Control

@export var act_editor_window: ActEditorWindow
@export var button: Button

func _on_button_pressed() -> void:
	var bit_data: BitData = BitData.randomise()
	bit_data.editor_data.position = get_viewport_rect().size / 2
	act_editor_window.graph.add_bit(bit_data)
	
