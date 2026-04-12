extends Entity
class_name Player

@onready var learned_skills: Array[SkillData] = skills.duplicate()
var target
var skill_in_casting: SkillData
var select_candidate

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("hotbar_1"):
		if not learned_skills.is_empty():
			skill_in_casting = learned_skills[0]
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if not target:
				select_candidate = {'candidate': target, 'position': get_global_mouse_position()}
		if event.button_index == MOUSE_BUTTON_LEFT && not event.pressed:
			if select_candidate && \
			target && \
			select_candidate['candidate'] == target:
				print('skill no %s' % select_candidate['candidate'].name)
				select_candidate = null

		if event.button_index == MOUSE_BUTTON_RIGHT && not event.pressed:
			skill_in_casting = null

func add_target(new_target: Node):
	target = new_target
	SignalBus.hover_over.emit(new_target)

func remove_target(new_target: Node): 
	if target == new_target: target = null
	SignalBus.hover_over.emit(target)
