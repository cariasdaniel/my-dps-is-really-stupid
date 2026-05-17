extends Control
class_name HotBar

@onready var slots = get_children()

var skill_selected: SkillData = null

func _ready():
	connect_slots()
	SignalBus.skill_slot_pressed.connect(_on_skill_slot_pressed)
	
	SignalBus.update_skills_ui.connect(update)

func connect_slots():
	for s: Button in slots:
		var callable = Callable(_on_skill_slot_pressed)
		callable = callable.bind(slots.find(s))
		s.pressed.connect(callable)

func update(skill):
	# If skill already in bar
	if update_skill_if_exists(skill): return
	
	# If no empty slots
	var empty_slots = slots.filter(func(s): return !s.skill)
	if empty_slots.size() == 0: return
	
	empty_slots[0].update(skill)

func update_skill_if_exists(skill: SkillData) -> bool:
	for slot: SkillSlot in slots:
		if !slot.skill: continue
		if slot.skill.id == skill.id: 
			slot.update(skill)
			return true
	return false

func _on_skill_slot_pressed(index):
	var slot = slots[index]
	if !slot.skill: return
	if slot.skill.cd_time_left > 0: return
	print("Using skill %s" % slot.skill.id)
	SignalBus.slot_has_skill.emit(slot.skill)
