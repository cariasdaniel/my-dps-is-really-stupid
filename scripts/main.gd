extends Node

@onready var player:= $Player

func _on_game_over_button_pressed() -> void:
	SceneChanger.change_to(ScenePath.gameOver)


func _on_settings_button_pressed() -> void:
	var settings = load(ScenePath.settings).instantiate()
	get_tree().root.add_child(settings)
	get_tree().paused = true


func _on_mana_button_pressed() -> void:
	SignalBus.change_mana.emit(player, 50)


func _on_pause_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
