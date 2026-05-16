extends Control
class_name ResourceBar
@onready var resource_bar: TextureProgressBar = $Texture
@onready var damage_bar: TextureProgressBar = $DamageBar
@onready var bar_text: Label = $Text

@onready var resource = resource_bar.max_value

func update_bar_values(current_resource, max_resource):
	resource_bar.max_value = max_resource
	
	var prev_res = resource
	resource = clampi(current_resource, 0, max_resource)
	resource_bar.value = resource
	
	bar_text.text = '%d / %d' % [resource, resource_bar.max_value]
	if resource < prev_res:
		await get_tree().create_timer(0.4).timeout
		damage_bar.value = resource_bar.value
	else:
		damage_bar.value = resource
