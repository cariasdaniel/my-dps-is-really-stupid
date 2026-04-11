extends State
class_name EnemyIdle

@onready var enemy: CharacterBody2D = $"../.."

var move_direction: Vector2
var wander_time: float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	get_tree().create_timer(3.0)

func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta):
	if enemy: enemy.velocity = move_direction * enemy.move_speed
	
