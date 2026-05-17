extends Button

class_name SkillListSlot

@onready var label: Label = $Label
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer

@export var skill : SkillData
@onready var item_sprite: TextureRect = $MarginContainer/ItemSprite

var selected: bool = false

func update(new_skill: SkillData):
	if !new_skill: return
	skill = new_skill
	item_sprite.texture = new_skill.icon
	label.text = "%s/%s" % [skill.current_level, skill.max_level]
	if skill.current_level > 0: panel_container.hide()

func _make_custom_tooltip(_n):
	if !skill:
		return null
	
	var tooltip = preload("res://modules/tooltip/tooltipScene.tscn").instantiate()
	tooltip.update(skill)
	
	return tooltip

# Drag and drop skill between slots
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !skill: return
	if skill.current_level == 0: return
	
	var preview: Control = item_sprite.duplicate()
	var c = Control.new() # Centers icon in cursor during drag
	c.add_child(preview)
	preview.position -= preview.custom_minimum_size / 2
	c.modulate = Color(c.modulate, 0.75)
	
	set_drag_preview(c)
	return self
	
func _can_drop_data(_at_potision: Vector2, _data: Variant) -> bool:
	return false
	
