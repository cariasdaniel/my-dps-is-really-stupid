extends State
class_name DpsAttack

@onready var dps: CharacterBody2D = $"../.."
var closest_target = null

func enter():
	print("DPS entered attack state")
	_get_closest_enemy_in_range()

func _get_closest_enemy_in_range():
	var closest_distance = INF
	for body in dps.search_area.get_overlapping_bodies():
		if not body.is_in_group('enemies'): continue
		var distance = (body.global_position - dps.global_position).length()
		if distance < closest_distance:
			closest_target = body

func _is_in_danger():
	for body in dps.safe_area.get_overlapping_bodies():
		if body.is_in_group('enemies'): return true
	return false

func physics_update(delta):
	var move_direction = closest_target.global_position - dps.global_position
	
	# If enemy enters safe area, run away
	if _is_in_danger():
		print("DANGER!!")
		transitioned.emit(self, 'idle')
		
	# If enemy not in range, walk in it's direction
	elif (move_direction.length() > dps.atk_range):
		print("Enemy left range - pursuing")
		dps.sprite.play('walk')
		dps.velocity = move_direction * dps.move_speed
		
	# If enemy in range, stop walking and attack
	elif move_direction.length() <= dps.atk_range:
		print("Enemy in range - attack!!")
		dps.velocity = Vector2(0, 0)
		if move_direction.x > 0: 
			dps.sprite.flip_h = false
		else:
			dps.sprite.flip_h = true
		dps.sprite.play('attack')
		#TODO: add attack effects
	
