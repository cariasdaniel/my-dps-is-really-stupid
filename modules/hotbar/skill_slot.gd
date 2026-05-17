extends Button

class_name SkillSlot

@onready var label: Label = $Label

@export var skill : SkillData
@onready var item_sprite: TextureRect = $MarginContainer/ItemSprite

@onready var cooldown_bar: TextureProgressBar = $MarginContainer/CooldownBar
@onready var timer: Timer = $CooldownTimer
@onready var cooldown_time_label: Label = $MarginContainer/CooldownTimeLabel

var selected: bool = false
var in_cooldown = false

func _ready() -> void:
	set_process(false)

func _process(_delta) -> void:
	cooldown_time_label.text = "%3.1f" % timer.time_left
	cooldown_bar.value = timer.time_left

func activate_skill(cooldown: float) -> void:
	if in_cooldown: return
	_start_cooldown_timer(cooldown)

func _start_cooldown_timer(cooldown: float) -> void:
	timer.wait_time = cooldown
	cooldown_bar.max_value = timer.wait_time
	
	timer.start()
	cooldown_bar.show()
	disabled = true
	in_cooldown = true
	set_process(true)

func _on_timer_timeout() -> void:
	timer.stop()
	
	disabled = false
	cooldown_bar.value = 0
	cooldown_bar.max_value = 0
	cooldown_time_label.text = ""
	cooldown_bar.hide()
	in_cooldown = false
	set_process(false)

func update(new_skill: SkillData, cooldown_time: float):
	if !new_skill:
		skill = null
		item_sprite.texture = null
		_on_timer_timeout()
		
	else:
		skill = new_skill
		item_sprite.texture = new_skill.icon
		if cooldown_time > 0: 
			_start_cooldown_timer(cooldown_time)
		else:
			_on_timer_timeout()
		
		label.text = "%s/%s" % [skill.current_level, skill.max_level]

func _make_custom_tooltip(_n):
	if !skill:
		return null
	
	var tooltip = preload("res://modules/tooltip/tooltipScene.tscn").instantiate()
	tooltip.update(skill)
	
	return tooltip

# Drag and drop skill between slots
func _get_drag_data(_at_position: Vector2) -> SkillSlot:
	if !skill: return
	
	var preview: Control = item_sprite.duplicate()
	var c = Control.new() # Centers icon in cursor during drag
	c.add_child(preview)
	preview.position -= preview.custom_minimum_size / 2
	c.modulate = Color(c.modulate, 0.75)
	
	set_drag_preview(c)
	return self
	
func _can_drop_data(_at_potision: Vector2, _data: Variant) -> bool:
	if get_parent() != SkillList: return false
	return true
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var skill_to_replace = skill
	var cd_left = timer.time_left
	update(data.skill, data.timer.time_left)
	data.update(skill_to_replace, cd_left)
	
