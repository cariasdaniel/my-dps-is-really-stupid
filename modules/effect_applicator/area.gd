extends EffectShape
class_name AreaEffect

var area: Area2D 
@export var _range: float
@export var _duration: float
@export var _ally_effects: Array[Effect]
@export var _enemy_effects: Array[Effect]
var bodies: Array

@export var _self_ignore: bool

var internal_clock:= 0.0

func _init(range: float = 100,
			ally_effects: Array[Effect] = [],
			enemy_effects: Array[Effect] = [], 
			duration:= 0.0,
			self_ignore:= true) -> void:
	_range = range
	_duration = duration
	_ally_effects = ally_effects
	_enemy_effects = enemy_effects
	_self_ignore = self_ignore

func _ready() -> void:
	area = Area2D.new()
	area.collision_layer = 1
	area.set_collision_mask_value(1, true) # players layer
	area.set_collision_mask_value(2, true) # enemies layer
	area.monitoring = true
	area.monitorable = true
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	
	circle_shape.radius = _range
	collision_shape.shape = circle_shape
	
	area.add_child(collision_shape)
	add_child(area)

func _physics_process(delta: float) -> void:
	bodies = area.get_overlapping_bodies()
	
	if not bodies.is_empty():
		apply_effects()
		internal_clock += delta
		if internal_clock >= _duration: queue_free()

func apply_effects() -> void:
	if _self_ignore:
		bodies.erase(get_parent())
			
	for body: PhysicsBody2D in bodies:
		for effect: Effect in _ally_effects:
			if body.is_in_group('players'):
				body.add_child(effect.create_copy())
		for effect: Effect in _enemy_effects:
			if body.is_in_group('enemies'):
				body.add_child(effect.create_copy())
