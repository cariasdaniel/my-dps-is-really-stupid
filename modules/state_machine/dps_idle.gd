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
		_move_to_player()
		return
		
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(0.1, 0.6)

func _move_to_player() -> void:
	move_direction = (player.global_position - dps.global_position).normalized()

func enter(options := {}):
	#print("Entered IDLE state")
	if options:
		overwritten = true
		wander_speed = options.wander_speed
		move_direction = (options.player_position - dps.global_position).normalized()
		return
	
	wander_speed = dps.move_speed
	randomize_wander()

func update(delta):
	if wander_time > 0 or overwritten:
		wander_time -= delta
	else:
		randomize_wander()


func physics_update(_delta):
	dps.velocity = move_direction * wander_speed
	
	if overwritten: 
		_move_to_player()
		return
	
	if not dps.get_enemies_in_range().is_empty():
		transitioned.emit(self, 'attack')


func _on_overwrite_timer_timeout() -> void:
	overwritten = false
	wander_speed = dps.move_speed
