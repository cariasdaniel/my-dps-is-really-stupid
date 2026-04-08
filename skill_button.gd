extends TextureButton
class_name SkillNode

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $MarginContainer/Label
@onready var line_2d: Line2D = $Line2D
var max_level: int

var current_level : int : 
	set(value):
		current_level = value
		label.text = "%s / %s" % [value, max_level]


func _ready():
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)


func create(skill: SkillData):
	texture_normal = skill.icon
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	toggle_mode = true
	z_index = 1
	max_level = skill.max_level
	current_level = skill.current_level


func _on_pressed() -> void:
	if current_level < max_level:
		current_level += 1
		color_rect.show_behind_parent = true
	
	# Change line color to demonstrate path is unlocked
	line_2d.default_color = Color(0.37, 0.229, 0.659, 1.0)
	
	var skill_tree = get_children()
	for skill in skill_tree:
		if skill is SkillNode and current_level == 1: # condition to unlock next skill
			skill.disabled = false
	
	
