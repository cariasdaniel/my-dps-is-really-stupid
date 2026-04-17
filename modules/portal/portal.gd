extends StaticBody2D

@onready var hp_bar: ProgressBar = $HpBar
@onready var portal_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var max_hp = 200
@export var current_hp = 200


func _ready() -> void:
	portal_sprite.play('default')
	SignalBus.deal_damage.connect(_on_damage_received)
	
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	
	_spawn_enemy()

func _on_time_to_spawn_timeout() -> void:
	_spawn_enemy()

func _spawn_enemy() -> void:
	var enemy = _select_enemy_to_spawn()
	var enemy_res: EnemyResource = enemy[0]
	var enemy_tscn: Node = enemy[1].instantiate()

	enemy_tscn.add_to_group("enemies")
	enemy_tscn.create_enemy(enemy_res)
	add_child(enemy_tscn)
	enemy_tscn.global_position = global_position + Vector2(randi_range(-20, 20), randi_range(-20, 20))

func _select_enemy_to_spawn() -> Array:
	var enemies = []
	
	var res_dir_name := "res://resources/enemies/"
	var tscn_dir_name := "res://scenes/enemies/"
	var file_names := DirAccess.get_files_at(res_dir_name)
	for file in file_names:
		var data = load(res_dir_name + file)
		if data.level > ExpManager.level: continue
		enemies.append(
			[data, load(tscn_dir_name + file.replace('tres', 'tscn'))]
		)
	return enemies.pick_random()


func _on_damage_received(target, value) -> void:
	if self != target: return
	current_hp = clamp(current_hp - value, 0, max_hp)
	if current_hp <= 0:
		queue_free()
		SignalBus.portal_destroyed.emit()
		return
		
	#TODO encapsulate HP Bar elsewhere?
	hp_bar.value = current_hp
