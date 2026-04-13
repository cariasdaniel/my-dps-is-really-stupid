extends State
class_name EnemyAttack

@onready var dps: CharacterBody2D = $"../.."

var normal_arrow = preload("res://modules/ammo/arrow_normal.tscn")

var can_attack: bool
var closest_target = null

func enter() -> void:
	#print("Entered ATTACK state")
	dps.velocity = Vector2.ZERO
	can_attack = true
	_get_closest_enemy_in_range()

func _get_closest_enemy_in_range():
	var closest_distance = INF
	closest_target = null
	for body in dps.get_enemies_in_range():
		var distance = (body.global_position - dps.global_position).length()
		if distance < closest_distance:
			closest_target = body

func _is_in_danger():
	for body in dps.safe_area.get_overlapping_bodies():
		if body.is_in_group('enemies'): return true
	return false


func physics_update(delta):
	if !can_attack: return
	
	# If enemy enters safe area, run away
	if _is_in_danger():
		#print("DANGER!!")
		transitioned.emit(self, 'flee')
		return
	
	_get_closest_enemy_in_range()
	
	# If no enemy in range, go back to idle state
	if closest_target == null:
		transitioned.emit(self, 'idle')
		return
		
	var direction = closest_target.global_position - dps.global_position
	_shoot_arrow(direction)

func _shoot_arrow(direction: Vector2) -> void:
	dps.sprite.play('attack_2')
	if direction.x > 0: 
		dps.sprite.flip_h = false
	else:
		dps.sprite.flip_h = true
		
	can_attack = false
	await dps.sprite.animation_finished
	
	var ammo: Area2D = normal_arrow.instantiate()
	get_tree().root.add_child(ammo)
	ammo.global_position = dps.global_position
	ammo.velocity = dps.atk_speed * 0.5
	ammo.direction = direction.normalized()
	
	can_attack = true
	
