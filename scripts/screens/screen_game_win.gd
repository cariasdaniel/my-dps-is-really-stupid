extends Control

@onready var timer = $Timer
@onready var timer2start = $Timer2
@onready var continue_button: Button = $ContinueButton

@onready var thought_labels = [
	$VBoxContainer/Label,
	$VBoxContainer/Label2,
	$VBoxContainer/Label3,
	$VBoxContainer/Label4,
	$VBoxContainer/HBoxContainer/Label6,
	$VBoxContainer/HBoxContainer/Label5
]

@onready var disclaimer = $VBoxContainer/Label7

var all_done = false

# function to show cutscene labels one by one
func _on_timer_timeout() -> void:
	if all_done: return
	
	# If disclaimer is visible
	# start timer to show "continue" button
	if disclaimer.visible:
		timer.queue_free()
		timer2start.start()
		return
	
	# if all thoughts labels are visible, add quotes
	# in first and last labels + show disclaimer
	var hidden_labels = thought_labels.filter(func(l: Label): return l.visible == false)
	if not hidden_labels:
		thought_labels[0].text = '"' + tr(thought_labels[0].text)
		thought_labels[-1].text = tr(thought_labels[-1].text) + '"'
		disclaimer.show()
		all_done = true
	
	# if not all thought labels are shown, show next
	for label: Label in hidden_labels:
		if !label.visible:
			label.modulate.a = 0.0
			var tween = create_tween()
			label.show()
			tween.tween_property(label, "modulate:a", 1.0, 1.0)
			break

# after all labels are visible, show "Continue" button
func _on_timer2start_timeout() -> void:
	continue_button.show_text()


# navigate to title screen
func _on_continue_button_pressed() -> void:
	SceneChanger.change_to(ScenePath.title)


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_released("ui_accept") 
		or event.is_action_released("ui_cancel")):
			if disclaimer.visible:
				_on_continue_button_pressed()
			else:
				_on_timer_timeout()
