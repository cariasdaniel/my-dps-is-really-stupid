extends Panel

@onready var timer = $Timer
@onready var timer2start = $Timer2

@onready var thought_labels = [
	$VBoxContainer/Label,
	$VBoxContainer/Label2,
	$VBoxContainer/Label3,
	$VBoxContainer/Label4,
	$VBoxContainer/Label5,
	$VBoxContainer/Label6
]

@onready var disclaimer = $VBoxContainer/Label7


func _on_timer_timeout() -> void:
	if disclaimer.visible:
		timer.autostart = false
		timer2start.start()
		return
		
	var hidden_labels = thought_labels.filter(func(l: Label): return l.visible == false)
	if not hidden_labels:
		thought_labels[0].text = '"' + thought_labels[0].text
		thought_labels[-1].text = thought_labels[-1].text + '"'
		disclaimer.show()
	
	for label: Label in hidden_labels:
		if !label.visible:
			label.modulate.a = 0.0
			var tween = create_tween()
			label.show()
			tween.tween_property(label, "modulate:a", 1.0, 1.0)
			break
