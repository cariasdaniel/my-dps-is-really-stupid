extends Control
class_name ResourceDisplay

@export var health_bar: ResourceBar
@export var mana_bar: ResourceBar
@export var entity: Entity

func _ready() -> void:
	if !entity: print("Resource bar with no entity assigned.")
		
	SignalBus.update_health_bar.connect(_on_change_health_move_bar)
	SignalBus.update_mana_bar.connect(_on_change_mana_move_bar)
	
	health_bar.update_bar_values(entity.current_hp, entity.max_hp)
	mana_bar.update_bar_values(entity.current_mana, entity.max_mana)
	

func _on_change_health_move_bar(target: Entity):
	if target != entity: return
	health_bar.update_bar_values(target.current_hp, target.max_hp)

func _on_change_mana_move_bar(target: Entity):
	if target != entity: return
	mana_bar.update_bar_values(target.current_mana, target.max_mana)

#func _change_max_values(target: Entity, new_max_hp, new_max_mana):
	#if target != entity: return
	#
	#health_bar.change_max_resource(new_max_hp)
	#mana_bar.change_max_resource(new_max_mana)
	
