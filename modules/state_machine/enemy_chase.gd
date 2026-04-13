extends State
class_name mobChase

@onready var mob: CharacterBody2D = $"../.."

var closest_target = null


func enter():
	print("Entered CHASE state")


func _get_closest_enemy_in_sight():
	var closest_distance = INF
	closest_target = null
	for body in mob.get_enemies_in_chase_area():
		var distance = (body.global_position - mob.global_position).length()
		if distance < closest_distance:
			closest_target = body
			
func physics_update(delta):
	_get_closest_enemy_in_sight()
	
	if mob.get_enemies_in_range().size() > 0:
		transitioned.emit(self, 'attack')
		return
	
	if !closest_target:
		transitioned.emit(self, 'idle')
		return
	
	var direction = closest_target.global_position - mob.global_position
	mob.velocity = direction.normalized() * mob.move_speed
