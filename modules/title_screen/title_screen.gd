extends Control

var settings_scene = preload("res://modules/settings/settings.tscn")

func _on_play_pressed() -> void:
	print("pressed Play")
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	var settings = settings_scene.instantiate()
	add_child(settings)
	get_tree().paused = true


func _on_quit_pressed() -> void:
	get_tree().quit()
