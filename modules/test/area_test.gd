extends Node2D

var bodies

func _process(delta: float) -> void:
	bodies = $Area2D.get_overlapping_bodies()
