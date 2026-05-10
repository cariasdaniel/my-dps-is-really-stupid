extends Entity
class_name Player

@onready var learned_skills: Array[SkillData] = skills.duplicate()
var target
var skill_in_casting: SkillData
var select_candidate

func _ready() -> void:
	SignalBus.died.connect(_on_death)
	SignalBus.level_up.connect(_on_level_up)
	SignalBus.use_skill.connect(_on_skill_use_add_effect)

func _unhandled_input(event: InputEvent) -> void:
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

func _on_skill_use_add_effect(index):
	if index == 0:
		var new_area = AreaEffect.new(
			100,
			[AreaHeal.new(int(max_hp * 0.1), self.global_position)],
			[],
			0.0,
			false
		)
		add_child(new_area)
	elif index == 1:
		var new_area = AreaEffect.new(
			100,
			[],
			[Knockback.new(800.0, self.global_position)]
		)
		add_child(new_area)
	elif index == 2:
		var new_area = AreaEffect.new(
			400,
			[],
			[Taunt.new(5.0, self)]
		)
		add_child(new_area)

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
	max_hp += int(max_hp * 0.10)
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
	SignalBus.update_health_bar.emit(self)
	SignalBus.update_mana_bar.emit(self)
	SignalBus.change_health.emit(self, recover)
	add_child(DamageTag.new(recover, Color.GREEN))
	
