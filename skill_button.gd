extends TextureButton
class_name SkillNode

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D

# TODO: update with actual skill levels later
const MAX_LEVEL = 3

var level : int = 0 : 
	set(value):
		level = value
		label.text = "%s | %s" % [value, MAX_LEVEL]


func _ready():
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)


func _on_pressed() -> void:
	level = min(level +1, MAX_LEVEL)
	color_rect.show_behind_parent = true
	
	line_2d.default_color = Color(0.37, 0.229, 0.659, 1.0)
	
	var skill_tree = get_children()
	for skill in skill_tree:
		if skill is SkillNode and level == 1:
			skill.disabled = false
	
	
