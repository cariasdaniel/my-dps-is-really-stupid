extends State
class_name DpsFlee

@onready var dps: CharacterBody2D = $"../.."
@onready var safe_area: Area2D = $"../../SafeArea"

@onready var flee_timer: Timer = $"../../FleeTime"

func enter():
	print("Entered FLEE state")
	flee_timer.wait_time = dps.flee_time
	flee_timer.start()

func physics_update(delta):
	var enemies = get_enemies_in_danger_zone()
	if enemies.is_empty(): return 
	
	var directions = Vector2.ZERO
	for body in enemies:
		directions += body.global_position

	#var player_pos = player.global_position.normalized()
	#var flee_direction = player_pos.lerp((directions / enemies.size() * -1), 0.4).normalized()
	var flee_direction = (directions / enemies.size()) * -1
	dps.velocity = flee_direction.normalized() * dps.flee_speed
	

func get_enemies_in_danger_zone():
	return dps.safe_area.get_overlapping_bodies().filter(func(b): return b.is_in_group('enemies'))
	

func _on_flee_time_timeout() -> void:
	var enemies = get_enemies_in_danger_zone()
	if enemies.is_empty():
		transitioned.emit(self, 'idle')
