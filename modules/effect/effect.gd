extends Node
class_name Effect

signal end_effect

@onready var target:Entity = get_parent()

func _ready() -> void:
	await end_effect
	queue_free()
