extends Area2D

@export var damage_value : float
var velocity := 20.0
var direction:= Vector2.ZERO

func set_damage(value):
	damage_value = value

func _on_body_entered(body: Node) -> void:
	if body.is_in_group('Allies') and not body.is_in_group('Player'): return
	
	if body.is_in_group('enemies') or body.is_in_group('portal'):
		SignalBus.deal_damage.emit(body, damage_value)
	queue_free()
	
func _process(delta: float) -> void:
	position += direction * velocity
	rotation = direction.angle()
