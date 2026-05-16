extends Effect
class_name Curse

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	#sprite = $AnimatedSprite2D
	#sprite.sprite_frames = _skill_data.enemy_target_vfx
	pass

func _ready() -> void:
	super()
	#sprite.scale = get_parent().sprite.scale
	
	SignalBus.deal_damage.emit(get_parent(), 
			int(_skill_data.vars.get('damage', 20) * _caster.attack / 100))
	end_effect.emit()
	

func create_copy(): return Curse.new(_caster, _source, _skill_data)
