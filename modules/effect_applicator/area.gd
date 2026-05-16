extends EffectShape
class_name AreaEffect

var _area: Area2D 
@export var _duration: float
@export var _n_aplication_times: int
@export var _apply_interval: float

@export var _caster_effects: Array[Effect]
@export var _ally_effects: Array[Effect]
@export var _enemy_effects: Array[Effect]
var bodies: Array

@export var _self_ignore: bool

var times_applied:= 0
var internal_duration_clock:= 0.0
var internal_apply_clock:= 0.0

func _init(
			skill: SkillData, # TODO: remove and improve
			area: Area2D, 
			duration: float = 0.0,
			caster_effects: Array[Effect] = [],
			ally_effects: Array[Effect] = [],
			enemy_effects: Array[Effect] = [],
			ignore_self: bool = false,
			) -> void:
	_area = area
	_caster_effects = caster_effects
	_ally_effects = ally_effects
	_enemy_effects = enemy_effects
	_duration = duration
	_self_ignore = ignore_self
	
	
	_apply_interval = skill.apply_interval
	_n_aplication_times = skill.n_apply_effects
	
	#area_animation = AnimatedSprite2D.new()
	#area_animation.sprite_frames = skill.area_vfx
	#var anim_scale = area.get_child(0).shape.radius / 50
	#area_animation.scale.x = anim_scale
	#area_animation.scale.y = anim_scale
	#_area.add_child(area_animation)
	
	add_child(_area)
	
func _physics_process(delta: float) -> void:
	if \
	times_applied >= _n_aplication_times or \
	(internal_duration_clock > _duration): 
		#if area_animation.sprite_frames: 
			#area_animation.sprite_frames.set_animation_loop('default', false)
			#if area_animation.is_playing(): await area_animation.animation_finished
		queue_free()
	
	internal_duration_clock += delta
	
	if internal_apply_clock > 0: # for non-immediate/over-time skills
		internal_apply_clock -= delta
		return
	
	bodies = _area.get_overlapping_bodies()
	
	if not bodies.is_empty():
		#area_animation.play()
		apply_effects()
		times_applied += 1
		internal_apply_clock = _apply_interval
		print("applied effects %s times" % times_applied)
	
	
func apply_effects() -> void:
	if _self_ignore:
		bodies.erase(get_parent())
		
	for body: PhysicsBody2D in bodies:
		for effect: Effect in _caster_effects:
			if body == get_parent():
				body.add_child(effect.create_copy())
				
		for effect: Effect in _ally_effects:
			if body.is_in_group('players'):
				body.add_child(effect.create_copy())
				
		for effect: Effect in _enemy_effects:
			if body.is_in_group('enemies'):
				body.add_child(effect.create_copy())
