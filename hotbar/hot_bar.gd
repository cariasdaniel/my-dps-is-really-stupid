extends Control

class_name HotBar

@export var skills : Array[SkillData]
@onready var slots = get_children()

func _ready():
	update()

func update():
	for i in range(slots.size()):
		slots[i].update(skills[i])
