extends State
class_name EnemyAttack

@onready var enemy: Enemy = $"../.."

var can_attack: bool
var is_attacking:= false
var target = null

func enter() -> void:
	print("Entered ATTACK state")
	enemy.velocity = Vector2.ZERO
	can_attack = true
	is_attacking = false
	target = null


func _get_closest_enemy_in_range():
	var closest_distance = INF
	target = null
	for body in enemy.get_enemies_in_range():
		var distance = (body.global_position - enemy.global_position).length()
		if distance < closest_distance:
			target = body


func physics_update(delta):
	if is_attacking: return
	
	_get_closest_enemy_in_range()
	# If no enemy to attack, try chase
	if !target:
		transitioned.emit(self, 'chase')
		return
	
	var direction = target.global_position - enemy.global_position
	_attack(direction)

func _attack(direction: Vector2) -> void:
	is_attacking = true
	enemy.sprite.play('attack')
	if enemy.position.direction_to(target.position).x > 0: 
		enemy.sprite.flip_h = true
	else:
		enemy.sprite.flip_h = false
		
	can_attack = false
	await enemy.sprite.animation_looped
	
	SignalBus.deal_damage.emit(target, enemy.attack)
	is_attacking = false
	
	await get_tree().create_timer(enemy.atk_speed).timeout
	can_attack = true
	
