extends State
class_name DpsIdle

@onready var player: Player = $"../../../Player"
@onready var dps: CharacterBody2D = $"../.."

@onready var search_area: Area2D = $"../../SearchArea"
@onready var safe_area: Area2D = $"../../SafeArea"

var move_direction: Vector2
var wander_speed: float
var wander_time: float

var overwritten: bool

func randomize_wander():
	if player not in search_area.get_overlapping_bodies():
		move_direction = (player.global_position - dps.global_position).normalized()
		return
		
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(0.1, 0.6)


func enter(options := {}):
	#print("Entered IDLE state")
	if options:
		overwritten = true
		wander_speed = options.wander_speed
		return
	
	wander_speed = dps.move_speed
	randomize_wander()

func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()


func physics_update(delta):
	if overwritten: return
	dps.velocity = move_direction * dps.move_speed
	
	if not dps.get_enemies_in_range().is_empty():
		transitioned.emit(self, 'attack')


func _on_overwrite_timer_timeout() -> void:
	overwritten = false
	wander_speed = dps.move_speed
