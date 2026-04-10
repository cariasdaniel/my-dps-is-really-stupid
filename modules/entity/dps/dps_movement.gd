extends Node
class_name DpsMovement

@onready var player = $"../../Player"
@onready var enemy = $"../../Enemy"

var direction:= Vector2.ZERO
var aim_direction:= Vector2.ZERO

var entity: CharacterBody2D

func _ready() -> void:
	entity = get_parent()

func set_target(target: CharacterBody2D) -> void:
	pass

func _process(delta: float) -> void:
	if entity.velocity.length() <= 0.1:
		pass #play idle
	else:
		pass #play moving
