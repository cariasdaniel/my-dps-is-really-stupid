extends CharacterBody2D
class_name Entity

@export var max_hp: int = 100
var current_hp:= 0.0
@export var hp_recovery: float = 1.0

@export var max_mana: int = 50
var current_mana:= 0.0
@export var mana_recovery: float = 0.5

@export var max_stress: int = 50
var current_stress:= 0.0
@export var stress_recovery: float = 0.1

@export var base_attack: int = 10
@export var attack: int = 10

@export var base_magic_power: int = 10
@export var magic_power: int = 10

@export var base_atk_speed:= 1.0
@export var atk_speed:= 1.0

@export var base_defense: float = 30.0
@export var defense: float = 30.0
@export var base_magic_defense: float = 30.0
@export var magic_defense: float = 30.0

@export var base_move_speed:= 100.0
@export var move_speed:= 100.0

@export var threat:= 100

@export var skills: Array[SkillData] = []

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _init() -> void:
	input_pickable = true
	
	mouse_entered.connect(_on_mouse_entered_target)
	mouse_exited.connect(_on_mouse_exited_untarget)
	
	current_hp = max_hp
	current_mana = max_mana
	
	var recovery_timer = Timer.new()
	recovery_timer.autostart = true
	recovery_timer.one_shot = false
	recovery_timer.wait_time = 5.0
	recovery_timer.timeout.connect(_on_recovery_timer_timeout)
	
	add_child(recovery_timer)
	
	SignalBus.deal_damage.connect(_on_damage_dealt_change_health)
	SignalBus.change_health.connect(_update_current_health)
	SignalBus.change_mana.connect(_update_current_mana)
	
func _on_mouse_entered_target():
	var player = get_tree().get_first_node_in_group("Player")
	assert(player, 'Player não instanciado')
	player.add_target(self)

func _on_mouse_exited_untarget():
	var player = get_tree().get_first_node_in_group("Player")
	assert(player, 'Player não instanciado')
	player.remove_target(self)

func _on_recovery_timer_timeout():
	if current_hp < max_hp:
		_update_current_health(self, hp_recovery)
	if current_mana < max_mana:
		_update_current_mana(self, mana_recovery)

func _on_damage_dealt_change_health(body, amount):
	if self != body: return
	var dmg_taken = _calculate_damage_taken(amount)
	_update_current_health(self, -dmg_taken)
	add_child(DamageTag.new(dmg_taken, Color.RED))
	print("%s took %s damage. %s health remaining" % [self, dmg_taken, current_hp])
	if current_hp <= 0:
		SignalBus.died.emit(self)

func _calculate_damage_taken(value) -> int:
	return max(int(value - (0.25 * defense)), 1)

func _update_current_health(target, value) -> void:
	if target != self: return
	current_hp = clampf(current_hp + value, 0, max_hp)
	if value > 0:
		print("%s updated health in %s. %s current health" % [self, value, current_hp])
		add_child(DamageTag.new(value, Color.GREEN))
	SignalBus.update_health_bar.emit(self)
	
func _update_current_mana(target, value) -> void:
	if target != self: return
	current_mana = clampf(current_mana + value, 0, max_mana)
	if value > 0: add_child(DamageTag.new(value, Color.DEEP_SKY_BLUE))
	SignalBus.update_mana_bar.emit(self)
