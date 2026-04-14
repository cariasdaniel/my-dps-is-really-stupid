extends Entity
class_name Enemy

var xp_reward:= 1.0

#TODO encapsulate HP Bar elsewhere?
@onready var hp_bar: ProgressBar = $HpBar
@onready var start_chase_area: Area2D = $StartChaseArea
@onready var attack_range: Area2D = $AttackRange

func _ready() -> void:
	SignalBus.change_health.connect(_on_health_changed)

func create_enemy(info: EnemyResource) -> void:
	max_hp = info.max_hp
	hp_recovery = info.hp_recovery

	max_mana = info.max_mana
	mana_recovery = info.mana_recovery

	attack = info.attack
	magic_power = info.magic_power

	defense = info.defense
	magic_defense = info.magic_defense

	move_speed = info.move_speed

	skills = info.skills

	xp_reward = info.xp_reward

	#sprite = info.sprite


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		sprite.play('walk')
	
	if velocity.x > 0: 
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	
func get_enemies_in_chase_area() -> Array:
	return start_chase_area.get_overlapping_bodies().filter(
		func(b): return b.is_in_group('Allies')
		)
	
	
func get_enemies_in_range() -> Array:
	return attack_range.get_overlapping_bodies().filter(
		func(b): return b.is_in_group('Allies')
		)

func _on_health_changed(target: Entity, value) -> void:
	if self != target: return
	current_hp = clamp(current_hp + value, 0, max_hp)
	if current_hp <= 0:
		SignalBus.gain_xp.emit(40)
		queue_free()
	
	#TODO encapsulate HP Bar elsewhere?
	hp_bar.value = current_hp
