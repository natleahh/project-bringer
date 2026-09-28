class_name EditorData extends Resource
var texture: Texture2D
var position: Vector2 = Vector2.ZERO

const PLACEHOLDER_TEXTURE: Array[Texture] = [
	preload("res://src/ActSystem/Data/PlaceHolder/Items0.png"),
	preload("res://src/ActSystem/Data/PlaceHolder/items1.png"),
	preload("res://src/ActSystem/Data/PlaceHolder/items2.png")
]

static func randomise() -> EditorData:
	var _editor_data = EditorData.new()
	_editor_data.texture = AtlasTexture.new()
	_editor_data.texture.atlas = PLACEHOLDER_TEXTURE[randi() % 3]
	var pos = Vector2i(randi() % 8, randi() % 8)
	_editor_data.texture.region = Rect2i(pos * 32, Vector2i.ONE * 32)
	return _editor_data
