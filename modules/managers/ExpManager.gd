extends Node

@export var base_xp = 100
@export var growth_rate = 1.15

@export var level: int = 1 : 
	get(): return level
@export var xp: float = 0 :
	get(): return xp

func _ready():
	SignalBus.gain_xp.connect(_calculate)
	_calculate(0)

func get_xp_to_next_level():
	return int(base_xp * (growth_rate ** (level - 1)))

func _calculate(xp_gained) -> void:
	var xp_needed = get_xp_to_next_level()
	var new_xp = xp + xp_gained
	if ((new_xp) >= xp_needed):
		level += 1
		xp =  new_xp - xp_needed
		print('leveled up!')
	else:
		xp += xp_gained
	
	SignalBus.update_xp_info.emit()
	print('emitting ui update')
