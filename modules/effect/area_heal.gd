extends Effect
class_name AreaHeal

var _heal_amount: int
var _source: Vector2

func _init(amount, source: Vector2) -> void:
	_heal_amount = amount
	_source = source

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	SignalBus.change_health.emit(get_parent(), _heal_amount)
	end_effect.emit()

func create_copy(): return AreaHeal.new(_heal_amount, _source)
