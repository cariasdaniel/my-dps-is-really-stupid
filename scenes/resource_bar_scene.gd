extends Control
@onready var timer = $Timer
@onready var resource_bar = $Texture
@onready var damage_bar = $DamageBar

@onready var resource = resource_bar.max_value : set = _set_resource

func _process(delta):
	if Input.is_action_pressed("lose_health"):
		_set_resource(resource - 1)
		
	if Input.is_action_pressed("gain_health"):
		_set_resource(resource + 1)

func _set_resource(new_resource):
	var prev_res = resource
	resource = min(resource_bar.max_value, new_resource)
	resource_bar.value = resource
	
	if resource < prev_res:
		timer.start()
	else:
		damage_bar.value = resource


func init_resource(_resource):
	resource = _resource
	resource_bar.max_value = resource
	resource_bar.value = resource
	damage_bar.max_value = resource
	damage_bar.value = resource


func _on_timer_timeout() -> void:
	damage_bar.value = resource_bar.value
