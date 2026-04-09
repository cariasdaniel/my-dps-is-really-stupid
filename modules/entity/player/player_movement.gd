extends Node
class_name PlayerMovement

var direction:= Vector2.ZERO
var aim_direction:= Vector2.ZERO

@export var max_speed:= 350
@export var acceleration:= 20
@export var friction:= 12

var entity: CharacterBody2D

func _ready() -> void:
	entity = get_parent()

func _process(delta: float) -> void:
	if entity.velocity.length()/max_speed <= 0.2:
		$"../AnimatedSprite2D".play("idle")
	else:
		$"../AnimatedSprite2D".play("walk")
		if entity.velocity.x < 0: $"../AnimatedSprite2D".flip_h = true
		elif entity.velocity.x > 0: $"../AnimatedSprite2D".flip_h = false
		$"../AnimatedSprite2D".speed_scale = entity.velocity.length()/max_speed

func _physics_process(delta: float) -> void:	
	var lerp_weight = delta * (acceleration if direction else friction)
	entity.velocity = lerp(entity.velocity, direction.normalized() * max_speed, lerp_weight)
	
	entity.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action("move_down") || event.is_action("move_up") || \
		   event.is_action("move_left") || event.is_action("move_right"):
			var dir:= Vector2.ZERO
			
			if event.is_action_pressed("move_down"):  dir+=Vector2.DOWN
			if event.is_action_released("move_down"): dir-=Vector2.DOWN
			
			if event.is_action_pressed("move_up"): dir+=Vector2.UP
			if event.is_action_released("move_up"): dir-=Vector2.UP
			
			if event.is_action_pressed("move_left"): dir+=Vector2.LEFT
			if event.is_action_released("move_left"): dir-=Vector2.LEFT
			
			if event.is_action_pressed("move_right"): dir+=Vector2.RIGHT
			if event.is_action_released("move_right"): dir-=Vector2.RIGHT
			
			direction += dir
	
	if event is InputEventMouseMotion:
		var mouse_pos = entity.get_global_mouse_position()
		aim_direction = entity.position.direction_to(mouse_pos)
