extends TextureButton

class_name SkillSlot

@export var skill : SkillData

func update(new_skill: SkillData):
	if !new_skill:
		texture_normal = load("res://assets/themes/hotbar-slot.png")
		
	else:
		skill = new_skill
		texture_normal = new_skill.icon
		

func _make_custom_tooltip(whatever):
	if !skill:
		return null
	
	var tooltip = preload("res://modules/tooltip/tooltipScene.tscn").instantiate()
	tooltip.update(skill)
	
	return tooltip
	
