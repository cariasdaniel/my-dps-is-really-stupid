extends Button

class_name SkillSlot

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
	
	timer.wait_time = cooldown
	cooldown_bar.max_value = timer.wait_time
	
	timer.start()
	cooldown_bar.show()
	disabled = true
	in_cooldown = true
	set_process(true)

func _on_timer_timeout() -> void:
	disabled = false
	cooldown_bar.value = 0
	cooldown_time_label.text = ""
	cooldown_bar.hide()
	in_cooldown = false
	set_process(false)

func update(new_skill: SkillData):
	if !new_skill:
		item_sprite = null
		
	else:
		skill = new_skill
		item_sprite.texture = new_skill.icon
		

func _make_custom_tooltip(_n):
	if !skill:
		return null
	
	var tooltip = preload("res://modules/tooltip/tooltipScene.tscn").instantiate()
	tooltip.update(skill)
	
	return tooltip
