extends Control

class_name HotBar

@export var skills : Array[SkillData]
@onready var slots = get_children()

var skill_selected: SkillData = null

func _ready():
	connect_slots()
	update()
	SignalBus.skill_slot_pressed.connect(_on_skill_slot_pressed)
	SignalBus.activate_skill.connect(_on_skill_activated)

func connect_slots():
	for s: Button in slots:
		var callable = Callable(_on_skill_slot_pressed)
		callable = callable.bind(slots.find(s))
		s.pressed.connect(callable)

func update():
	for i in range(slots.size()):
		if i >= skills.size(): break
		slots[i].update(skills[i], 0)

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
