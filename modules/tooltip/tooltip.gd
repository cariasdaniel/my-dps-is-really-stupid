extends Control

func update(skill: SkillData):
	$MarginContainer/VBoxContainer/Label.text = skill.name
	$MarginContainer/VBoxContainer/Label2.text = "Cost: %s MP" % skill.cost
	$MarginContainer/VBoxContainer/Label3.text = "Cooldown: %s sec" % skill.cooldown
	$MarginContainer/VBoxContainer/Label5.text = skill.description % skill.vars
	
