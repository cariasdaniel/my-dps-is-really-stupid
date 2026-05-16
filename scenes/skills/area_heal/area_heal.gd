extends Effect
class_name AreaHeal

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	#sprite = $AnimatedSprite2D
	#sprite.sprite_frames = _skill_data.ally_target_vfx
	#sprite.scale = _caster.sprite.scale

func _ready() -> void:
	super()
	
	SignalBus.change_health.emit(get_parent(), 
			int(_skill_data.vars.get('heal_percentage', 10) * _caster.max_hp / 100))
	end_effect.emit()
	
func create_copy(): return AreaHeal.new(_caster, _source, _skill_data)
