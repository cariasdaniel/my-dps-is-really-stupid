extends Control
@onready var resource_bar = $Texture
@onready var damage_bar = $DamageBar

@onready var resource = resource_bar.max_value : set = _set_resource

func _process(delta):
	if Input.is_action_pressed("lose_health"):
		_set_resource(resource - 5)
		
	if Input.is_action_pressed("gain_health"):
		_set_resource(resource + 10)

func _set_resource(new_resource):
	var prev_res = resource
	resource = min(resource_bar.max_value, new_resource)
	resource_bar.value = resource
	
	if resource < prev_res:
		await get_tree().create_timer(0.4).timeout
		damage_bar.value = resource_bar.value
	else:
		damage_bar.value = resource


func init_resource(_resource):
	resource = _resource
	resource_bar.max_value = resource
	resource_bar.value = resource
	damage_bar.max_value = resource
	damage_bar.value = resource
