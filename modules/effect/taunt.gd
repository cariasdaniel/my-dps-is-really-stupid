extends Effect
class_name Taunt
#
#signal end_effect
#
#@onready var target:Entity = get_parent()
#
#func _ready() -> void:
	#await end_effect
	#queue_free()

var duration: float
var priority_target: Entity

func _init(dur: float, body: Entity) -> void:
	duration = dur
	priority_target = body

func _ready() -> void:
	target.set_priority_target(priority_target)
	await get_tree().create_timer(duration).timeout
	target.set_priority_target(null)
	end_effect.emit()

func create_copy(): return Taunt.new(duration, priority_target)
