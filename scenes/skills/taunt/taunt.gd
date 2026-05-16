extends Effect
class_name Taunt
#
#signal end_effect
#
#@onready var target:Entity = get_parent()
#
#func _ready() -> void:
	#await end_effect
	#queue_free()

var duration: float
var priority_target: Entity

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	
	duration = _skill_data.duration
	priority_target = _caster
	
	#sprite = $AnimatedSprite2D
	#sprite.sprite_frames = _skill_data.enemy_target_vfx

func _ready() -> void:
	super()
	
	#sprite.sprite_frames.set_animation_loop('default', true)
	#sprite.scale = get_parent().sprite.scale
	
	target.set_priority_target(priority_target)
	await get_tree().create_timer(duration).timeout
	#sprite.sprite_frames.set_animation_loop('default', false)
	target.set_priority_target(null)
	end_effect.emit()

func create_copy(): return Taunt.new(_caster, _source, _skill_data)
