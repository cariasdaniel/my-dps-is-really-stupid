extends State
class_name DpsFlee

@onready var player = $"../../../Player"
@onready var dps: CharacterBody2D = $"../.."

@onready var search_area: Area2D = $"../../SearchArea"
@onready var safe_area: Area2D = $"../../SafeArea"


func enter():
	print("Entered FLEE state")

func update(delta):
	pass

func physics_update(delta):
	var enemies = get_enemies_in_danger_zone()
	if enemies.is_empty(): 
		transitioned.emit(self, 'idle')
		return
	
	var directions = Vector2(0, 0)
	for body in enemies:
		directions += body.global_position

	var player_pos = player.global_position
	var flee_direction = player_pos.lerp((directions / enemies.size() * -1), 0.2).normalized()
	dps.velocity = flee_direction * dps.move_speed

func get_enemies_in_danger_zone():
	return dps.safe_area.get_overlapping_bodies().filter(func(b): return b.is_in_group('enemies'))
	
