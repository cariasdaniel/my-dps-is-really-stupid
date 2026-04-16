extends Entity
class_name Enemy

var xp_reward:= 1.0

#TODO encapsulate HP Bar elsewhere?
@onready var hp_bar: ProgressBar = $HpBar
@onready var start_chase_area: Area2D = $StartChaseArea
@onready var attack_range: Area2D = $AttackRange
var priority_target = null

func _ready() -> void:
	SignalBus.deal_damage.connect(_on_damage_received)
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp


func create_enemy(info: EnemyResource) -> void:
	max_hp = info.max_hp
	current_hp = info.max_hp
	hp_recovery = info.hp_recovery

	max_mana = info.max_mana
	current_mana = info.max_mana
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

func set_priority_target(body):
	priority_target = body

func get_enemies_in_chase_area() -> Array:
	return start_chase_area.get_overlapping_bodies().filter(
		func(b): return b.is_in_group('Allies')
		)
	
	
func get_enemies_in_range() -> Array:
	return attack_range.get_overlapping_bodies().filter(
		func(b): return b.is_in_group('Allies')
		)
	
	
func _on_damage_received(body, amount) -> void:
	if self != body: return
	
	current_hp -= amount
	add_child(DamageTag.new(amount, Color.RED))
	if current_hp <= 0:
		SignalBus.gain_xp.emit(xp_reward)
		queue_free()
	
	#TODO encapsulate HP Bar elsewhere?
	hp_bar.value = current_hp
