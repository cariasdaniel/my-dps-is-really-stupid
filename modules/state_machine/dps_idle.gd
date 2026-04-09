extends State
class_name DpsIdle

@onready var player = $"../../../../Player"
@onready var dps: CharacterBody2D = $"../../.."
@onready var safe_area: Area2D = $"../../../SafeArea"

@export var move_speed:= 100.0

var move_direction: Vector2
var wander_time: float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	if player not in safe_area.get_overlapping_bodies():
		print("finding player")
		move_direction = (player.global_position - dps.global_position).normalized()

func enter():
	randomize_wander()

func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta):
	dps.velocity = move_direction * move_speed
	dps.move_and_slide()
	
