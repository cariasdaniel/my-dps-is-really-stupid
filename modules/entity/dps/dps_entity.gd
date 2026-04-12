extends Entity
class_name Dps

@export var atk_speed:= 30

@export var flee_time := 1.5
@export var flee_speed := move_speed

@onready var atk_range_area: CollisionShape2D = $SearchArea/AtkRangeArea
@export var base_area : float = 10.0
var radius_scalar :float = 1.0 :
	set(new_scalar):
		radius_scalar = new_scalar
		_change_atk_range()

@onready var search_area: Area2D = $SearchArea
@onready var safe_area: Area2D = $SafeArea

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		sprite.play('walk')
		if velocity.x > 0: 
			sprite.flip_h = false
		else:
			sprite.flip_h = true


func get_enemies_in_range() -> Array:
	return search_area.get_overlapping_bodies().filter(func(b): return b.is_in_group('enemies'))


func _change_atk_range():
	atk_range_area.shape.set_deferred("radius", base_area * radius_scalar)
	
