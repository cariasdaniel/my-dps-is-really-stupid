extends State
class_name DpsAttack

@onready var dps: CharacterBody2D = $"../.."
var can_attack = true

var closest_target = null

func enter() -> void:
	print("Entered ATTACK state")
	_get_closest_enemy_in_range()

func _get_closest_enemy_in_range():
	var closest_distance = INF
	closest_target = null
	for body in dps.get_enemies_in_range():
		var distance = (body.global_position - dps.global_position).length()
		if distance < closest_distance and distance <= dps.atk_range:
			closest_target = body

func _is_in_danger():
	for body in dps.safe_area.get_overlapping_bodies():
		if body.is_in_group('enemies'): return true
	return false


func physics_update(delta):
	# If enemy enters safe area, run away
	if _is_in_danger():
		print("DANGER!!")
		transitioned.emit(self, 'flee')
		return
		
	_get_closest_enemy_in_range()
	
	# If no enemy in range, go back to idle state
	if closest_target == null:
		transitioned.emit(self, 'idle')
		return
		
	var direction = closest_target.global_position - dps.global_position
	
	dps.velocity = Vector2(0, 0)
	if direction.x > 0: 
		dps.sprite.flip_h = false
	else:
		dps.sprite.flip_h = true
	dps.sprite.play('attack')
	# TODO implement attack effects
	_shoot_arrow(direction)

func _shoot_arrow(direction: Vector2) -> void:
	print("Attacked!")
	SignalBus.change_health.emit(closest_target, -1)
	
