extends State
class_name EnemyIdle

@onready var enemy: CharacterBody2D = $"../.."

var move_direction: Vector2
var wander_time: float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	print("Entered IDLE state")
	get_tree().create_timer(3.0)

func update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()

func physics_update(delta):
	enemy.velocity = move_direction * enemy.move_speed
	
	if not enemy.get_enemies_in_range().is_empty():
		transitioned.emit(self, 'attack')
		
	if get_tree().get_nodes_in_group('players'):
		transitioned.emit(self, 'chase')
	
