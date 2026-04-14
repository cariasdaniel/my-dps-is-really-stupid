extends CanvasLayer

@onready var music_slider = $AudioPanel/MarginContainer/GridContainer/MasterSlider

func _on_ok_button_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_master_slider_value_changed(value: float) -> void:
	SignalBus.on_master_volume_changed.emit(value)

func _on_music_slider_value_changed(value: float) -> void:
	SignalBus.on_music_volume_changed.emit(value)

func _on_sfx_volume_value_changed(value: float) -> void:
	SignalBus.on_sfx_volume_changed.emit(value)
