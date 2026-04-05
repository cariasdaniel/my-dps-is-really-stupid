extends Control


func _on_play_pressed() -> void:
	print("pressed Play")
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	print("pressed Settings")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()

# TODO: create setting menu and connecting to volume slider
func _on_h_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
