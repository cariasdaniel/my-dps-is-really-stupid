extends Entity
class_name Dps

@export var move_speed:= 100.0

@export var atk_speed:= 30
@export var atk_range:= 400

@export var flee_time = 1.5

@onready var search_area: Area2D = $SearchArea
@onready var safe_area: Area2D = $SafeArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	
