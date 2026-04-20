extends Node

@onready var player:= $Player


func _on_game_over_button_pressed() -> void:
	SceneChanger.change_to(ScenePath.gameOver)


func _on_settings_button_pressed() -> void:
	var settings = load(ScenePath.settings).instantiate()
	get_tree().root.add_child(settings)
	get_tree().paused = true
