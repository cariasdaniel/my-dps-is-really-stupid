extends Control
class_name HotBar

@onready var slots = get_children()

var skill_selected: SkillData = null

func _ready():
	connect_slots()
	SignalBus.skill_slot_pressed.connect(_on_skill_slot_pressed)
	SignalBus.activate_skill.connect(_on_skill_activated)
	
	SignalBus.update_skills_ui.connect(update)

func connect_slots():
	for s: Button in slots:
		var callable = Callable(_on_skill_slot_pressed)
		callable = callable.bind(slots.find(s))
		s.pressed.connect(callable)

func update(known_skills):
	for skill in known_skills:
		# If skill already in bar
		if update_skill_if_exists(skill): continue
		
		# If no empty slots
		var empty_slots = slots.filter(func(s): return !s.skill)
		if empty_slots.size() == 0: return
		
		empty_slots[0].update(skill, 0)

func update_skill_if_exists(skill: SkillData) -> bool:
	for slot: SkillSlot in slots:
		if !slot.skill: continue
		if slot.skill.id == skill.id: 
			slot.update(skill, slot.timer.time_left)
			return true
	return false

func _on_skill_slot_pressed(index):
	var slot = slots[index]
	if !slot.skill: return
	if slot.in_cooldown: return
	print("Using skill %s" % slot.skill.id)
	SignalBus.slot_has_skill.emit(slot.skill)

func _on_skill_activated(skill: SkillData, cooldown: float) -> void:
	var slot: SkillSlot = slots.filter(func(s: SkillSlot): return s.skill == skill)[0]
	if !slot: push_error("hot_bar.gd: slot not found")
	slot.activate_skill(cooldown)
