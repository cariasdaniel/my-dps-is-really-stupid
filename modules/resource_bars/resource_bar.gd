extends Control
class_name ResourceBar
@onready var resource_bar: TextureProgressBar = $Texture
@onready var damage_bar: TextureProgressBar = $DamageBar
@onready var bar_text: Label = $Text

@onready var resource = resource_bar.max_value : set = set_resource

func change_max_resource(value):
	resource_bar.max_value += value
	damage_bar.max_value += value
	bar_text.text = '%d / %d' % [resource, resource_bar.max_value]
	if value > 0:
		set_resource(value)

func change_resource(value):
	set_resource(resource + value)

func set_resource(new_resource):
	var prev_res = resource
	resource = clamp(new_resource, 0, resource_bar.max_value)
	resource_bar.value = resource
	
	bar_text.text = '%d / %d' % [resource, resource_bar.max_value]
	if resource < prev_res:
		await get_tree().create_timer(0.4).timeout
		damage_bar.value = resource_bar.value
	else:
		damage_bar.value = resource
