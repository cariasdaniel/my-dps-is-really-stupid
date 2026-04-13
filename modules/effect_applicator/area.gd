extends Node2D
class_name AreaEffect

signal end_effect

var area: Area2D 
var _range
var _duration
var _ally_effects: Array[Effect]
var _enemy_effects: Array[Effect]
var bodies: Array

var _self_ignore

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
	area.collision_mask = 1
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
