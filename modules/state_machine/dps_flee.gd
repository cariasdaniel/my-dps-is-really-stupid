extends State
class_name DpsFlee

@onready var player = $"../../../Player"
@onready var dps: CharacterBody2D = $"../.."

@onready var search_area: Area2D = $"../../SearchArea"
@onready var safe_area: Area2D = $"../../SafeArea"


func enter():
	#print("Entered FLEE state")
	pass

func update(delta):
	pass

func physics_update(delta):
	# TODO: change to avoid flickery behavior
	var enemies = get_enemies_in_danger_zone()
	if enemies.is_empty():
		transitioned.emit(self, 'idle')
		return
	
	var directions = Vector2.ZERO
	for body in enemies:
		directions += body.global_position.normalized()

	#var player_pos = player.global_position.normalized()
	#var flee_direction = player_pos.lerp((directions / enemies.size() * -1), 0.4).normalized()
	var flee_direction = (directions / enemies.size()) * -1
	dps.velocity = flee_direction * dps.move_speed

func get_enemies_in_danger_zone():
	return dps.safe_area.get_overlapping_bodies().filter(func(b): return b.is_in_group('enemies'))
	
