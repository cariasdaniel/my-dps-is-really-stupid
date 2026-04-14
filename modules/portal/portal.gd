extends StaticBody2D

@onready var hp_bar: ProgressBar = $HpBar
@onready var portal_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var max_hp = 200
@export var current_hp = 200

const enemy_scene = preload("uid://nlpb0sqhemm8")

func _ready() -> void:
	portal_sprite.play('default')
	SignalBus.change_health.connect(_on_health_changed)
	
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

func _on_time_to_spawn_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy_data = _select_enemy_to_spawn()

	enemy.add_to_group("enemies")
	enemy.create_enemy(enemy_data)
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position + Vector2(randi_range(-20, 20), randi_range(-20, 20))

# TODO: spawn different enemies depending on game state
func _select_enemy_to_spawn() -> EnemyResource:
	var enemies = []
	
	var dir_name := "res://resources/enemies/"
	var file_names := DirAccess.get_files_at(dir_name)
	for file in file_names:
		enemies.append(load(dir_name + file))
	return enemies[0]


func _on_health_changed(target, value) -> void:
	if self != target: return
	current_hp = clamp(current_hp + value, 0, max_hp)
	if current_hp <= 0:
		queue_free()
		SignalBus.portal_destroyed.emit()
		return
		
	#TODO encapsulate HP Bar elsewhere?
	hp_bar.value = current_hp
