extends Entity
class_name Dps

@export var flee_time := 1.5
@export var flee_speed := move_speed

@onready var atk_range_area: CollisionShape2D = $SearchArea/AtkRangeArea
@export var base_area : float = 10.0
var radius_scalar :float = 1.0 :
	set(new_scalar):
		radius_scalar = new_scalar
		_change_atk_range()

@onready var search_area: Area2D = $SearchArea
@onready var safe_area: Area2D = $SafeArea

func _ready():
	SignalBus.died.connect(_on_death)
	SignalBus.level_up.connect(_on_level_up)


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		sprite.play('walk')
		if velocity.x > 0: 
			sprite.flip_h = false
		else:
			sprite.flip_h = true


func get_enemies_in_range() -> Array:
	return search_area.get_overlapping_bodies().filter(func(b): return b.is_in_group('enemies'))


func _change_atk_range():
	atk_range_area.shape.set_deferred("radius", base_area * radius_scalar)
	

func _on_death(body):
	if self != body: return
	print("DPS died")
	SceneChanger.change_to(ScenePaths.gameOver)


func _on_level_up():
	max_hp += int(max_hp * 0.08)
	hp_recovery += 0.5

	max_mana += int(max_mana * 0.1)
	mana_recovery *= 1.1

	attack += int(attack * 0.15)
	magic_power += int(magic_power * 0.1)
	atk_speed *= 1.15

	defense += int(defense * 0.08)
	magic_defense += int(magic_defense * 0.08)
	
	move_speed += 5
	flee_speed *= 1.05
	sprite.speed_scale += 0.1
	
	var recover = int(max_hp * 0.33)
	SignalBus.change_health.emit(self, recover)
	SignalBus.update_resource_bars.emit(self, max_hp, max_mana)
	add_child(DamageTag.new(recover, Color.GREEN))
	
