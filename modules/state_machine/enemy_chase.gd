extends State
class_name mobChase

@onready var mob: CharacterBody2D = $"../.."

var target = null

func enter():
	print("Entered CHASE state")


func _get_closest_enemy_in_sight():
	if mob.priority_target:
		target = mob.priority_target
	else:
		for body: Entity in get_tree().get_nodes_in_group('players'):
			if target != body:
				if not target || body.threat > target.threat:
						target = body

func physics_update(delta):
	_get_closest_enemy_in_sight()
	
	if mob.get_enemies_in_range().size() > 0:
		transitioned.emit(self, 'attack')
		return
	
	#if !target:
		#transitioned.emit(self, 'idle')
		#return
	
	var direction = target.global_position - mob.global_position
	mob.velocity = direction.normalized() * mob.move_speed
