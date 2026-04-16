extends CharacterBody2D
class_name Entity

@export var max_hp: int = 100
var current_hp:= 0.0
@export var hp_recovery: float = 1.0

@export var max_mana: int = 50
var current_mana:= 0.0
@export var mana_recovery: float = 0.5

@export var attack: int = 10
@export var magic_power: int = 10
@export var atk_speed:= 1.0

@export var defense: float = 30.0
@export var magic_defense: float = 30.0

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
	recovery_timer.timeout.connect(_on_recovery_timer_timeout_recover_hp)
	
	add_child(recovery_timer)
	
	SignalBus.deal_damage.connect(_on_damage_dealt_change_health)
	

func _on_mouse_entered_target():
	var player = get_tree().get_first_node_in_group("Player")
	assert(player, 'Player não instanciado')
	player.add_target(self)

func _on_mouse_exited_untarget():
	var player = get_tree().get_first_node_in_group("Player")
	assert(player, 'Player não instanciado')
	player.remove_target(self)

func _on_recovery_timer_timeout_recover_hp():
	if current_hp < max_hp:
		current_hp += hp_recovery
		SignalBus.change_health.emit(self, hp_recovery)
		add_child(DamageTag.new(hp_recovery, Color.GREEN))
	if current_mana < max_mana:
		current_mana += mana_recovery
		SignalBus.change_mana.emit(self, mana_recovery)
		add_child(DamageTag.new(mana_recovery, Color.DEEP_SKY_BLUE))

func _on_damage_dealt_change_health(body, amount):
	if self != body: return
	
	var dmg_taken = _calculate_damage_taken(amount)
	current_hp -= dmg_taken
	add_child(DamageTag.new(dmg_taken, Color.RED))
	SignalBus.change_health.emit(self, -dmg_taken)
	if current_hp <= 0:
		SignalBus.died.emit(self)
	
func _calculate_damage_taken(value) -> int:
	return max(int(value - (0.25 * defense)), 1)
