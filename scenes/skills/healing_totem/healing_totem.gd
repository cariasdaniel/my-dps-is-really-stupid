extends OverTimeEffect
class_name HealingTotem

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	
	_max_application_times = skill.n_apply_effects
	_application_interval = skill.apply_interval
	_duration = skill.duration

	#sprite = $AnimatedSprite2D
	#sprite.sprite_frames = _skill_data.ally_target_vfx
	#sprite.scale = _caster.sprite.scale

func _ready() -> void:
	super()
	
	SignalBus.change_health.emit(get_parent(), 
			int(_skill_data.vars.get('heal_percentage', 10) * _caster.max_hp / 100))
	end_effect.emit()
	
func _process(delta) -> void:
	_internal_duration_clock += delta
	
	# TODO: right now calculation is within area.gd
	# refactor this later
	
	#if _times_applied == _max_application_times \
	#or _internal_duration_clock >= _duration:
		#end_effect.emit()
		#return
	#
	#if _internal_apply_clock > 0: 
		#_internal_apply_clock -= delta
		#return
		
	#SignalBus.change_health.emit(get_parent(), 
			#int(_skill_data.vars.get('heal_percentage', 10) * _caster.max_hp / 100))
	#
	#_internal_apply_clock = _application_interval
	#_times_applied += 1
	
func create_copy(): return HealingTotem.new(_caster, _source, _skill_data)
