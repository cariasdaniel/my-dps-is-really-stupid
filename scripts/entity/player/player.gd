extends Entity
class_name Player

@onready var learned_skills: Array[SkillData] = skills.duplicate()
var target
var skill_in_casting: SkillData
var select_candidate

func _ready() -> void:
	SignalBus.died.connect(_on_death)
	SignalBus.level_up.connect(_on_level_up)

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

func _on_death(body):
	if self != body: return
	print("Player died")
	SceneChanger.change_to(ScenePath.gameOver)

func _on_level_up():
	max_hp += int(max_hp * 0.15)
	hp_recovery += 1.5

	max_mana += int(max_mana * 0.1)
	mana_recovery *= 1.1

	attack = int(attack * 0.1)
	magic_power = int(magic_power * 0.1)
	atk_speed *= 1.1

	defense = int(defense * 1.2)
	magic_defense = int(magic_defense * 1.15)
	
	var recover = int(max_hp * 0.25)
	current_hp += recover
	SignalBus.change_health.emit(self, recover)
	SignalBus.update_resource_bars.emit(self, max_hp, max_mana)
	add_child(DamageTag.new(recover, Color.GREEN))
	
