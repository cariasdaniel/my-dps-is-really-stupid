extends Node
class_name DpsMovement

@onready var player = $"../../Player"
@onready var enemy = $"../../Enemy"

var direction:= Vector2.ZERO
var aim_direction:= Vector2.ZERO

@export var attack_range:= 175.0
@export var curr_speed:= 500.0

@onready var safe_area: Area2D = $"../SafeArea"

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

func _on_safe_area_body_entered(body: Node2D) -> void:
	if body == player:
		print("Hello friend")
	if body == enemy:
		print("Enemy spotted")
	# Switch focus to enemy that just entered
