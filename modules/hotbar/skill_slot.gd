extends Button

class_name SkillSlot

@export var skill : SkillData
@onready var item_sprite: TextureRect = $MarginContainer/ItemSprite

var selected: bool = false

func update(new_skill: SkillData):
	if !new_skill:
		item_sprite = null
		
	else:
		skill = new_skill
		item_sprite.texture = new_skill.icon
		

func _make_custom_tooltip(whatever):
	if !skill:
		return null
	
	var tooltip = preload("res://modules/tooltip/tooltipScene.tscn").instantiate()
	tooltip.update(skill)
	
	return tooltip
