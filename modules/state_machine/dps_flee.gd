extends State
class_name DpsFlee

@onready var dps: CharacterBody2D = $"../.."
@onready var safe_area: Area2D = $"../../SafeArea"

@onready var flee_timer: Timer = $"../../FleeTime"

var target_position := Vector2.ZERO
var overwritten: bool

func enter(options := {}):
	print("Entered FLEE state")
	if options:
		overwritten = true
		target_position = options.target_position
	else:
		flee_timer.wait_time = dps.flee_time
		flee_timer.start()

func physics_update(delta):
	var flee_direction : Vector2
	if overwritten:
		if dps.global_position != target_position:
			flee_direction = (target_position - dps.global_position).normalized()
			dps.velocity = flee_direction.normalized() * dps.flee_speed
		else:
			SignalBus.force_transitioned.emit('idle', { 'wander_speed': Vector2.ZERO })
		return

	var enemies = get_enemies_in_danger_zone()
	if enemies.is_empty(): return 
	
	var mob_directions = Vector2.ZERO
	for body in enemies:
		mob_directions += body.global_position

	#var player_pos = player.global_position.normalized()
	#var flee_direction = player_pos.lerp((directions / enemies.size() * -1), 0.4).normalized()
	flee_direction = (mob_directions / enemies.size()) * -1
	dps.velocity = flee_direction.normalized() * dps.flee_speed
	
	

func get_enemies_in_danger_zone():
	return dps.safe_area.get_overlapping_bodies().filter(func(b): return b.is_in_group('enemies'))
	

func _on_flee_time_timeout() -> void:
	var enemies = get_enemies_in_danger_zone()
	if enemies.is_empty():
		transitioned.emit(self, 'idle')


func _on_overwrite_timer_timeout() -> void:
	overwritten = false
