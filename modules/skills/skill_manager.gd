extends Node
class_name SkillManager

@onready var caster = $".."
var skill_list: Dictionary[String, SkillData]
var skill_cooldown: Dictionary[String, float]

func _ready() -> void:
	SignalBus.slot_has_skill.connect(_mount_skill_effect)
	
	_load_skill_list()
	print("Skill Manager ready")
	print("caster: " + str(caster))

func _load_skill_list() -> void:
	var dir_name := "res://resources/skills/"
	var file_names := DirAccess.get_files_at(dir_name)
	for file in file_names:
		var file_name = dir_name + file.trim_suffix('.remap')
		var data : SkillData = load(file_name)
		skill_list[data.id] = data
	
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
