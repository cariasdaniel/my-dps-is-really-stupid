extends Node

@onready var player:= $Player

func _process(delta: float) -> void:
	if Input.is_action_pressed("gain_health"):
		SignalBus.change_mana.emit(player, 10)
	if Input.is_action_pressed("lose_health"):
		SignalBus.change_mana.emit(player, -10)
