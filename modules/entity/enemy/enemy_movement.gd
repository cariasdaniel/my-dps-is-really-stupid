extends Node
class_name EnemyMovement

var direction:= Vector2.ZERO
var aim_direction:= Vector2.ZERO

@export var attack_range:= 175.0

var entity: CharacterBody2D

func _ready() -> void:
	entity = get_parent()
	print("loaded enemy movement")

func set_target(target: CharacterBody2D) -> void:
	pass

func _process(delta: float) -> void:
	if entity.velocity.length() <= 0.1:
		pass #play idle
	else:
		pass #play moving

func _on_safe_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('players'):
		print("Found a player")
	 #Switch focus to enemy that just entered
