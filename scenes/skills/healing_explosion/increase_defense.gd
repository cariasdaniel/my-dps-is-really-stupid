extends Effect
class_name IncreaseDefense

var _defense_increase: int

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	
	_defense_increase = _skill_data.vars.get('defense_increase', 20)
	
	#sprite = $AnimatedSprite2D
	#sprite.sprite_frames = _skill_data.self_vfx
	#sprite.scale = _caster.sprite.scale

func _ready() -> void:
	super()
	
	print("applied increase defense")
	# TODO: INCREASE CASTER'S DEFENSE
	
func create_copy(): return IncreaseDefense.new(_caster, _source, _skill_data)
