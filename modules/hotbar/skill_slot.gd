extends Button

class_name SkillSlot

@export var skill : SkillData
@onready var item_sprite: TextureRect = $MarginContainer/ItemSprite

@onready var cooldown_bar: TextureProgressBar = $MarginContainer/CooldownBar
@onready var cooldown_time_label: Label = $MarginContainer/CooldownTimeLabel

var selected: bool = false

func _ready():
	SignalBus.start_cooldown.connect(start_cooldown_timer)

func _process(delta) -> void:
	if !skill: 
		on_cooldown_time_end()
		return
	
	if skill.cd_time_left <= 0:
		on_cooldown_time_end()
		return
		
	cooldown_time_label.text = "%3.1f" % skill.cd_time_left
	cooldown_bar.value = skill.cd_time_left
	
	skill.cd_time_left -= delta

func start_cooldown_timer(active_skill: SkillData) -> void:
	if skill != active_skill: return
	
	skill.cd_time_left = skill.cooldown
	cooldown_bar.max_value = skill.cooldown
	
	cooldown_bar.show()
	disabled = true

func on_cooldown_time_end() -> void:
	disabled = false
	cooldown_bar.value = 0
	cooldown_bar.max_value = 0
	cooldown_time_label.text = ""
	cooldown_bar.hide()

func update(new_skill: SkillData):
	if !new_skill:
		skill = null
		item_sprite.texture = null
		
	else:
		skill = new_skill
		item_sprite.texture = new_skill.icon

func _make_custom_tooltip(_n):
	if !skill:
		return null
	
	var tooltip = preload("res://modules/tooltip/tooltipScene.tscn").instantiate()
	tooltip.update(skill)
	
	return tooltip

# Drag and drop skill between slots
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !skill: return
	
	var preview: Control = item_sprite.duplicate()
	var c = Control.new() # Centers icon in cursor during drag
	c.add_child(preview)
	preview.position -= preview.custom_minimum_size / 2
	c.modulate = Color(c.modulate, 0.75)
	
	set_drag_preview(c)
	return self
	
func _can_drop_data(_at_potision: Vector2, _data: Variant) -> bool:
	return true
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var skill_to_replace = skill
	update(data.skill)
	data.update(skill_to_replace)
	
