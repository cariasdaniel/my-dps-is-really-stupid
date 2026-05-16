extends Effect
class_name Call

var duration: float
var destination: Vector2

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	
	duration = _skill_data.duration
	destination = _caster.global_position
	
	#sprite = $AnimatedSprite2D
	#sprite.sprite_frames = _skill_data.ally_target_vfx

func _ready() -> void:
	super()
	
	#sprite.sprite_frames.set_animation_loop('default', true)
	#sprite.scale = get_parent().sprite.scale
	
	SignalBus.force_transitioned.emit('idle', duration, { 'wander_speed': 120, 'player_position': destination })
	await get_tree().create_timer(duration).timeout
	#sprite.sprite_frames.set_animation_loop('default', false)
	end_effect.emit()
	
	# TODO: IMPROVE THIS
	# Currently we have 2 different timers to handle this effect:
	# the one in here, that ends the effect and queue_free() the scene
	# and a Timer in the DPS scene (under StateMachine) that triggers
	# the end of the "overwritten" state

func create_copy(): return Call.new(_caster, _source, _skill_data)
