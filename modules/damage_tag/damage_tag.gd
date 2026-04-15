extends Label
class_name DamageTag

@onready var parent:= get_parent

func _init(value: float, color: Color) -> void:
	modulate = color
	text = str(int(value))
	set_anchors_preset(PRESET_CENTER_BOTTOM)
	position.y -= 50

func _ready() -> void:
	var direction_x:= (randf() * 100.0) - 50.0
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_property(self, 'position:y', position.y - 50, 1.0)
	tween.tween_property(self, 'position:x', position.x + direction_x, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(self.queue_free)
