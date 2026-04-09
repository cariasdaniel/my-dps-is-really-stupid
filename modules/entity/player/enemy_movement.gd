extends Node
class_name EnemyMovement

var direction:= Vector2.ZERO
var aim_direction:= Vector2.ZERO

@export var curr_speed:= 500.0

var entity: CharacterBody2D

func _ready() -> void:
	entity = get_parent()

func _process(delta: float) -> void:
	if entity.velocity.length() <= 0.1:
		pass #play idle
	else:
		pass #play moving

func _physics_process(_delta: float) -> void:
	entity.velocity = direction.normalized() * curr_speed
	entity.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action("enemy_down") || event.is_action("enemy_up") || \
		   event.is_action("enemy_left") || event.is_action("enemy_right"):
			var dir:= Vector2.ZERO
			
			if event.is_action_pressed("enemy_down"):  dir+=Vector2.DOWN
			if event.is_action_released("enemy_down"): dir-=Vector2.DOWN
			
			if event.is_action_pressed("enemy_up"): dir+=Vector2.UP
			if event.is_action_released("enemy_up"): dir-=Vector2.UP
			
			if event.is_action_pressed("enemy_left"): dir+=Vector2.LEFT
			if event.is_action_released("enemy_left"): dir-=Vector2.LEFT
			
			if event.is_action_pressed("enemy_right"): dir+=Vector2.RIGHT
			if event.is_action_released("enemy_right"): dir-=Vector2.RIGHT
			
			direction += dir
	
	#if event is InputEventMouseMotion:
		#var mouse_pos = entity.get_global_mouse_position()
		#aim_direction = entity.position.direction_to(mouse_pos)
		#print(aim_direction)
