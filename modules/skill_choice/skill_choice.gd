extends CanvasLayer

@onready var option_1: Button = $HBoxContainer/Option1
@onready var icon_1: TextureRect = $HBoxContainer/Option1/VBoxContainer/Icon1
@onready var skill_tooltip1: Control = $HBoxContainer/Option1/VBoxContainer/SkillTooltip

@onready var option_2: Button = $HBoxContainer/Option2
@onready var icon_2: TextureRect = $HBoxContainer/Option2/VBoxContainer/Icon2
@onready var skill_tooltip2: Control = $HBoxContainer/Option2/VBoxContainer/SkillTooltip

@onready var continue_button: Button = $ContinueButton

var options_to_choose: Array[SkillData]

func _ready():
	get_tree().paused = true

func populate_options(options):
	options_to_choose = options
	
	var skill1 = options[0]
	icon_1.texture = skill1.icon
	skill_tooltip1.update(skill1)
	
	var skill2 = options[1]
	icon_2.texture = skill2.icon
	skill_tooltip2.update(skill2)

func _on_option_1_pressed() -> void:
	print('option 1 selected')
	_handle_choice(option_1)
	SignalBus.learn_skill.emit(options_to_choose[0])

func _on_option_2_pressed() -> void:
	print('option 2 selected')
	_handle_choice(option_2)
	SignalBus.learn_skill.emit(options_to_choose[1])

func _handle_choice(choice: Button) -> void:
	var discarded = option_2 if choice == option_1 else option_1
	discarded.disabled = true
	var tween = create_tween()
	tween.tween_property(discarded, "modulate:a", 0.0, 1.0)
	await tween.finished
	discarded.hide()
	
	
	continue_button.show_text()

func _on_continue_button_pressed() -> void:
	queue_free()
	get_tree().paused = false
