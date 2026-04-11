extends Entity
class_name Enemy

@export var move_speed = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.change_health.connect(_on_health_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		sprite.play('walk')
	else:
		sprite.play('idle')
	
	if velocity.x > 0: 
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
		
func _on_health_changed(target: Entity, value) -> void:
	if self != target: return
	current_hp = clamp(current_hp + value, 0, max_hp)
	if current_hp <= 0:
		SignalBus.gain_xp.emit(40)
		queue_free()
