extends State
class_name DpsIdle

@onready var player = $"../../../Player"
@onready var dps: CharacterBody2D = $"../.."

@onready var search_area: Area2D = $"../../SearchArea"
@onready var safe_area: Area2D = $"../../SafeArea"

var move_direction: Vector2
var wander_time: float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(0.1, 0.6)
	if player not in search_area.get_overlapping_bodies():
		move_direction = (player.global_position - dps.global_position).normalized()

func enter():
	randomize_wander()

func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta):
	dps.velocity = move_direction * dps.move_speed


func _on_safe_area_body_entered(body: Node2D) -> void:
	if body == player:
		print("Hello friend")
	if body.is_in_group("enemies"):
		print("Enemy spotted")
		transitioned.emit(self, 'attack')
