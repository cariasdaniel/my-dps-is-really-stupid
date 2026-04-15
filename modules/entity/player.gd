extends Entity
class_name Player

@onready var learned_skills: Array[SkillData] = skills.duplicate()
var target
var skill_in_casting: SkillData
var select_candidate

func _ready() -> void:
	SignalBus.deal_damage.connect(_on_damage_dealt_change_health)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("hotbar_1"):
		if not learned_skills.is_empty():
			skill_in_casting = learned_skills[0]
	if event.is_action_released("hotbar_2"):
		var new_area = AreaEffect.new(
			100,
			[],
			[Knockback.new(800.0, self.global_position)]
		)
		add_child(new_area)
	if event.is_action_released("hotbar_3"):
		var new_area = AreaEffect.new(
			400,
			[],
			[Taunt.new(5.0, self)]
		)
		add_child(new_area)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
#			When click press, mark the current target as candidate for the action
			if target:
				select_candidate = {'candidate': target, 'position': get_global_mouse_position()}
		if event.button_index == MOUSE_BUTTON_LEFT && not event.pressed:
#			If the current target is the current candidate, do an action on him, if possible
			if select_candidate && \
			target && \
			select_candidate['candidate'] == target:
				print('Ação ativada no %s' % select_candidate['candidate'].name)
				select_candidate = null
				if skill_in_casting:
					print('> Skill conjurada: %s' % skill_in_casting.name)
					skill_in_casting = null
					var eff = Knockback.new(500.0, self.position)
					target.add_child(eff)

		if event.button_index == MOUSE_BUTTON_RIGHT && not event.pressed:
#			Cancels current skill cast, if casting
			skill_in_casting = null

func add_target(new_target: Node):
	target = new_target
	SignalBus.hover_over.emit(target)

func remove_target(new_target: Node): 
	if target == new_target: target = null
	SignalBus.hover_over.emit(target)

func _on_damage_dealt_change_health(body, amount):
	if self != body: return
	
	current_hp -= amount
	add_child(DamageTag.new(amount, Color.RED))
	SignalBus.change_health.emit(self, -amount)
	if current_hp <= 0:
		SceneChanger.change_to(ScenePaths.gameOver)
