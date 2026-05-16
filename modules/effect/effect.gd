extends Node
class_name Effect

#var sprite: AnimatedSprite2D

var _caster: Entity
var _source: Vector2
var _skill_data: SkillData

signal end_effect

@onready var target:Entity = get_parent()

func _ready() -> void:
	#if sprite: sprite.play()
	await end_effect
	#if sprite and sprite.is_playing(): await sprite.animation_finished
	finish()

func _init(caster: Entity, source: Vector2, skill: SkillData) -> void:
	_caster = caster
	_source = source
	_skill_data = skill

func finish():
	queue_free()
