extends Control
class_name ResourceDisplay

@export var health_bar: ResourceBar
@export var mana_bar: ResourceBar
@export var entity: Entity

func _ready() -> void:
	if entity:
		SignalBus.change_health.connect(_on_change_health_move_bar)
		SignalBus.change_mana.connect(_on_change_mana_move_bar)
		
		health_bar.change_max_resource(entity.max_hp)
		health_bar.set_resource(entity.current_hp)
		mana_bar.change_max_resource(entity.max_mana)
		mana_bar.set_resource(entity.current_mana)

func _on_change_health_move_bar(target: Entity, value):
	if target != entity: return

	health_bar.change_resource(value)

func _on_change_mana_move_bar(target: Entity, value):
	if target != entity: return

	mana_bar.change_resource(value)
