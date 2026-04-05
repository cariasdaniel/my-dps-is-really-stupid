extends Control

class_name HotBar

@export var skills : Array[SkillData]
@onready var slots = get_children()

var skill_selected: SkillData = null

func _ready():
	connect_slots()
	update()


func connect_slots():
	for s: Button in slots:
		var callable = Callable(on_slot_clicked)
		callable = callable.bind(s)
		s.pressed.connect(callable)
		
func update():
	for i in range(slots.size()):
		slots[i].update(skills[i])

func on_slot_clicked(slot):
	if !slot.skill: return
	
	if !skill_selected:
		skill_selected = slot.skill
		print("Skill selected is " + str(skill_selected.name))
		SignalBus.skill_selected.emit(skill_selected)
	else:
		print("deselected skill " + skill_selected.name)
		skill_selected = null
