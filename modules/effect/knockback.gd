extends Effect
class_name Knockback

var _knockback: Vector2
var _force
var _source: Vector2
@export var friction:= 0.1

func _init(force: float, source: Vector2) -> void:
	_force = force
	_source = source

func _ready() -> void:
	_knockback = _force * _source.direction_to(target.position)
	super()

func _physics_process(_delta: float) -> void:
	target.velocity = _knockback
	_knockback = lerp(_knockback, Vector2.ZERO, friction)
	
	if _knockback.length() <= 0.5:
		SignalBus.interrupt.emit(get_parent())
		end_effect.emit()

func create_copy(): return Knockback.new(_force, _source)
