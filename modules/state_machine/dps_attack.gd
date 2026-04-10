extends State
class_name DpsAttack

@onready var dps: CharacterBody2D = $"../.."
@onready var enemy: CharacterBody2D = $"../../../Enemy"

func enter():
	print("DPS entered attack state")
	pass
	
func physics_update(delta):
	var move_direction = enemy.global_position - dps.global_position
	
	# If enemy enters safe area, run away
	if enemy in dps.safe_area.get_overlapping_bodies():
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
	
