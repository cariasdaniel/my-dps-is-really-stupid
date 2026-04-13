extends State
class_name DpsAttack

@onready var enemy: Enemy = $"../.."

var can_attack: bool
var target = null

func enter() -> void:
	print("Entered ATTACK state")
	enemy.velocity = Vector2.ZERO
	can_attack = true


func _get_closest_enemy_in_range():
	var closest_distance = INF
	target = null
	for body in enemy.get_enemies_in_range():
		var distance = (body.global_position - enemy.global_position).length()
		if distance < closest_distance:
			target = body


func physics_update(delta):
	if !can_attack: return
	
	_get_closest_enemy_in_range()
	
	# If no enemy to attack, try chase
	if !target:
		transitioned.emit(self, 'chase')
		return
	
	var direction = target.global_position - enemy.global_position
	_attack(direction)

func _attack(direction: Vector2) -> void:
	enemy.sprite.play('attack')
	if direction.x > 0: 
		enemy.sprite.flip_h = false
	else:
		enemy.sprite.flip_h = true
		
	can_attack = false
	await enemy.sprite.animation_finished
	
	SignalBus.change_health.emit(target, enemy.attack)
	print("ATTACKING!!!!")
	
	can_attack = true
	
