extends Control

func _on_play_pressed() -> void:
	print("pressed Play")
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	var settings = load(ScenePaths.settings).instantiate()
	add_child(settings)
	get_tree().paused = true


func _on_quit_pressed() -> void:
	get_tree().quit()
