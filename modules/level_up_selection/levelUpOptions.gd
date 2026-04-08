extends Control

@onready var option_1: Button = $HBoxContainer/Option1
@onready var icon_1: TextureRect = $HBoxContainer/Option1/VBoxContainer/Icon1
@onready var skill_tooltip1: Control = $HBoxContainer/Option1/VBoxContainer/SkillTooltip

@onready var option_2: Button = $HBoxContainer/Option2
@onready var icon_2: TextureRect = $HBoxContainer/Option2/VBoxContainer/Icon2
@onready var skill_tooltip2: Control = $HBoxContainer/Option2/VBoxContainer/SkillTooltip

func _ready():
	_populate_options()

func _select_skills() -> Array[SkillData]:
	var skills = [
		preload("res://resources/skills/call.tres"),
		preload("res://resources/skills/engage.tres"),
		preload("res://resources/skills/recover.tres"),
		preload("res://resources/skills/defend.tres"),
		preload("res://resources/skills/retreat.tres"),
		preload("res://resources/skills/smite.tres"),
		preload("res://resources/skills/speed.tres"),
		preload("res://resources/skills/wait.tres"),
	]
	var s1 = skills.pick_random()
	var s2 = skills.pick_random()
	return [s1, s2]
	
func _populate_options():
	var skills = _select_skills()
	var skill1 = skills[0]
	icon_1.texture = skill1.icon
	skill_tooltip1.update(skill1)
	
	var skill2 = skills[1]
	icon_2.texture = skill2.icon
	skill_tooltip2.update(skill2)
	

func _on_option_1_pressed() -> void:
	print('option 1 selected')
	option_2.disabled = true
	var tween = create_tween()
	tween.tween_property(option_2, "modulate:a", 0.0, 1.0)
	await tween.finished
	option_2.hide()

func _on_option_2_pressed() -> void:
	print('option 2 selected')
	option_1.disabled = true
	var tween = create_tween()
	tween.tween_property(option_1, "modulate:a", 0.0, 1.0)
	await tween.finished
	option_1.hide()
