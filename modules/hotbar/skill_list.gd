extends Control
class_name SkillList

const SKILL_SLOT = preload("uid://d31aqjwq6ns5r")

@onready var grid_container: GridContainer = $GridContainer

var all_skills: Dictionary[String,SkillData] = {}
var slots: Array[SkillListSlot] = []

func _ready() -> void:
	all_skills = Utils.load_skill_list()
	_update_list()
	hide()
	
	SignalBus.update_skills_ui.connect(_update_skill)
	
func _update_list() -> void:
	for skill in all_skills.values():
		var btn = SKILL_SLOT.instantiate()
		slots.append(btn)
		grid_container.add_child(btn)
		btn.update(skill)
		if btn.skill.current_level == 0: btn.disabled = true
		btn.label.text = "%s/%s" % [btn.skill.current_level, btn.skill.max_level]
		btn.label.show()
	
func _update_skill(skill: SkillData) -> void:
	for slot in slots:
		if !slot.skill: continue
		if slot.skill.id != skill.id: continue
		
		slot.update(skill)
		slot.disabled = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("open_skill_tree"):
		visible = !visible

func _on_close_button_pressed() -> void:
	hide()
