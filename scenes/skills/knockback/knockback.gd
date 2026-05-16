extends Effect
class_name Knockback

var _knockback: Vector2
@export var friction:= 0.1

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	super(caster, source, skill)
	#sprite = AnimatedSprite2D.new()
	#sprite.sprite_frames = _skill_data.enemy_target_vfx
	#add_child(sprite)
	pass

func _ready() -> void:
	_knockback = _skill_data.vars.force * _source.direction_to(target.position)
	super()
	

func _physics_process(_delta: float) -> void:
	target.velocity = _knockback
	_knockback = lerp(_knockback, Vector2.ZERO, friction)
	
	if _knockback.length() <= 0.5:
		SignalBus.interrupt.emit(target)
		end_effect.emit()

func create_copy(): return Knockback.new(_caster, _source, _skill_data)
