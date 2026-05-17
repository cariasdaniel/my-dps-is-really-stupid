extends Node
class_name SkillManager

@onready var caster: Entity = $".."

var all_skills: Dictionary[String, SkillData]
var skill_cooldown: Dictionary[String, float]

var SKILL_GAIN_LVL := 4
var TIER_UPGRADE_LVL_MULTIPLIER := 8

func _ready() -> void:
	SignalBus.slot_has_skill.connect(_mount_skill_effect)
	SignalBus.learn_skill.connect(_learn_skill)
	
	all_skills = Utils.load_skill_list()
	print("Skill Manager ready")
	print("caster: " + str(caster))

func _mount_skill_effect(skill: SkillData) -> void:
	if skill.cost_type == SkillData.resource_cost.MANA:
		if caster.current_mana < skill.cost: return
	elif skill.cost_type == SkillData.resource_cost.STRESS:
		if caster.current_stress >= skill.cost: return
	
	if skill.minimum_targets > 0 and !caster.target: return
	
	# Determine effects
	var caster_effects: Array[Effect] = []
	var ally_effects: Array[Effect] = []
	var enemy_effects: Array[Effect] = []
	
	# TODO: grab effect from skill recaster
	for e: Script in skill.self_effects:
		var skill_effect: Effect = e.new(caster, caster.global_position, skill)
		caster_effects.append(skill_effect)
		
	for e: Script in skill.ally_effects:
		var skill_effect: Effect = e.new(caster, caster.global_position, skill)
		ally_effects.append(skill_effect)
	
	for e: Script in skill.enemy_effects:
		var skill_effect: Effect = e.new(caster, caster.global_position, skill)
		enemy_effects.append(skill_effect)
	
	# Determine skill shape
	var area : Area2D
	if skill.shape == SkillData.shapes.CIRCLE: 
		area = Utils.create_circular_area_2d(skill.area)
		
	elif skill.shape == SkillData.shapes.LINE:
		area = Utils.create_rectangular_area_2d(skill.size)

	# Ally and enemy effects will be applied from AREA_EFFECT scene
	var effect_applicator = AreaEffect.new(
		skill,
		area,
		skill.duration,
		caster_effects,
		ally_effects,
		enemy_effects,
		skill.ignore_self
	)
	
	# Determine if distance is enough to cast skill
	if skill.distance > 0 and skill.minimum_targets == 0:
		# "Area": apply effects to bodies within map area
		var cast_position = get_viewport().get_mouse_position()
		if (cast_position - caster.global_position).length() > skill.distance:
			print("Can't cast %s - too far away" % skill.name)
			return
		effect_applicator.global_position = cast_position
		
		get_tree().root.add_child(effect_applicator)
	elif skill.distance > 0 and caster.target:
		# "Bolt": apply effects to target within range
		var target: CharacterBody2D = caster.target
		if target == caster and skill.ignore_self: return
		if target.is_in_group('players') and !len(skill.ally_effects): return
		if target.is_in_group('enemies') and !len(skill.enemy_effects): return
		if target.is_in_group('portal'): return
		
		target.add_child(effect_applicator)
	else:
		# "Aura": apply effects around caster
		caster.add_child(effect_applicator)
	
	# Initiate skill (consume resources & initiate cooldown)
	SignalBus.change_mana.emit(caster, -skill.cost)
	SignalBus.activate_skill.emit(skill, skill.cooldown)


func pick_skills_to_acquire() -> Array[SkillData]:
	""" Filter 'acquirable' skills to show upon level up """
	var option1: SkillData = null
	var option2: SkillData = null
	
	var available_skills = all_skills.duplicate()
	var minimum_tier = floori(ExpManager.level / TIER_UPGRADE_LVL_MULTIPLIER)
	
	# Update available skills based on caster data
	for s in caster.learned_skills:
		# No skills already maxxed
		if s.current_level == s.max_level: available_skills.erase(s.id)
		
		# Filter by tier
		if s.tier > minimum_tier: available_skills.erase(s.id)
		
		# Dependencies must be met
		for req in s.dependencies.keys():
			var caster_req_skill = caster.learned_skills.filter(func(s): return s.id == req)
			# Pre-requisite is learned
			if !(caster_req_skill): available_skills.erase(s.id)
			# Pre-requisite level is met
			elif !(s.dependencies[req] > caster_req_skill[0].current_level): available_skills.erase(s.id)
		
		available_skills[s.id] = s 
	
	var skill_pool = available_skills.values()
	# Failsafe in case there are less than 2 options to select
	if skill_pool.size() < 2: return [null, null]
	
	while option1 == option2:
		option1 = skill_pool.pick_random()
		option2 = skill_pool.pick_random()
	return [option1, option2]
		
	#else:
		#var skills = [
			#preload("res://resources/status_update/attackUpgrade.tres"),
			#preload("res://resources/status_update/defenseUpgrade.tres"),
			#preload("res://resources/status_update/magicDefenseUpgrade.tres"),
		#]
		#var s1 = skills.pick_random()
		#var s2 = skills.pick_random()
		#return [s1, s2]


func _learn_skill(skill: SkillData) -> void:
	var is_learned = caster.learned_skills.find(skill)
	if is_learned < 0: caster.learned_skills.append(skill)
	else:
		caster.learned_skills[is_learned].current_level += 1
		# TODO: update skill stats on skill level up
	
	SignalBus.update_skills_ui.emit(caster.learned_skills)
