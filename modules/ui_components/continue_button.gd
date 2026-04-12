extends Button

func show_text():
	var tween = create_tween()
	show()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)
