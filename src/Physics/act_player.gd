class_name ActPlayer extends Node

signal tock

@onready var timer: Timer = $Timer:
	set(_timer):
		_timer.timeout.connect(_tick)

var _current_bit: BitNode
var current_connector: BitConnector

var current_bit: BitNode:
	get:
		return _current_bit
	set(c):
		set_current(c)

var next: Array[BitConnector]:
	get:
		return (
			current_bit.selected
			# filter out current connector
			.filter(func (c): return c != current_connector)
			# extract selected node partners
			.map(func (c): return c.partner)
		)
var graph: ActGraph

func set_current(_bit: BitNode) -> void:
	if _current_bit != null:
		_current_bit.play_end.emit()
	if _bit != null:
		_bit.play_start.emit()
	_current_bit = _bit

func play_from(_bit: BitNode) -> void:
	current_bit = _bit
	current_connector = null
	timer.start()

func _tick() -> void:
	if not timer.is_stopped() or current_bit == null:
		return
	match next as Array:
		[var next_connector]:
			current_bit.play_end.emit()
			next_connector.bit.play_start.emit()
			current_bit = next_connector.bit
			current_connector = next_connector
			tock.emit()
			timer.start()

func _on_timer_timeout() -> void:
	_tick()
