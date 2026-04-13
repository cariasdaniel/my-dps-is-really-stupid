extends Node

@onready var player:= $Player

func _process(delta: float) -> void:
	if Input.is_action_pressed("gain_health"):
		SignalBus.change_mana.emit(player, 10)
	if Input.is_action_pressed("lose_health"):
		SignalBus.change_mana.emit(player, -10)
		

func _on_game_over_button_pressed() -> void:
	SceneChanger.change_to(ScenePaths.gameOver)


func _on_settings_button_pressed() -> void:
	var settings = load(ScenePaths.settings).instantiate()
	get_tree().root.add_child(settings)
	get_tree().paused = true
