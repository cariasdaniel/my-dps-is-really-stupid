extends DelayedEffect
class_name HealingExplosion

var explosion_area: Area2D

var _damage_taken: float
var _heal_multiplier: float

var _healing_amount: int

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	
	delay_time = skill.duration
	
	_heal_multiplier = skill.vars.damage_percentage / 100.0
	explosion_area = Utils.create_circular_area_2d(skill.area)
	
	#sprite = AnimatedSprite2D.new()
	#sprite.sprite_frames = skill.area_vfx

func _ready() -> void:
	super()
	print("applied healing explosion")
	
	SignalBus.deal_damage.connect(_accumulate_damage)
	
	#sprite.scale = get_parent().sprite.scale
	#add_child(sprite)
	
	_healing_amount = int(_damage_taken * _heal_multiplier)
	add_child(explosion_area)
	
	SignalBus.change_health.emit(get_parent(), _healing_amount)
	end_effect.emit()
	

func _accumulate_damage(tgt, value) -> void:
	if tgt != get_parent(): return
	_damage_taken += value


func create_copy(): return HealingExplosion.new(_caster, _source, _skill_data)
