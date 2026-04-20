extends State
class_name DpsAttack

@onready var dps: CharacterBody2D = $"../.."

var can_attack: bool
var closest_target = null

var overwritten: bool

func enter(options := {}) -> void:
	#print("Entered ATTACK state")
	dps.velocity = Vector2.ZERO
	can_attack = true
	_get_closest_enemy_in_range()
	if options:
		print("Entered ATTACK state on PLAYER's COMMAND")
		closest_target = options.target
		

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
	if _is_in_danger() and not overwritten:
		#print("DANGER!!")
		transitioned.emit(self, 'flee')
		return
	
	if not overwritten: _get_closest_enemy_in_range()
	
	# If no enemy in range, go back to idle state
	if closest_target == null and not overwritten:
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
	
	var selected_ammo = _select_ammo()
	var ammo_scene: Area2D = selected_ammo.instantiate()
	get_tree().root.add_child(ammo_scene)
	ammo_scene.set_damage(dps.attack)
	ammo_scene.global_position = dps.global_position
	ammo_scene.direction = direction.normalized()
	
	can_attack = true

func _select_ammo() -> PackedScene:
	return load(ScenePath.arrow_normal)

func _on_overwrite_timer_timeout() -> void:
	overwritten = false
