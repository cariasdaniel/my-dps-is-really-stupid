extends Node

# Area 2D Creation
func create_area_2d(coll_layer = 1, colls_masks = [1, 2]) -> Area2D:
	var area = Area2D.new()
	area.collision_layer = coll_layer
	for mask in colls_masks:
		area.set_collision_mask_value(mask, true)
	area.monitoring = true
	area.monitorable = true
	return area

func create_circular_area_2d(radius, coll_layer = 1, colls_masks = [1, 2]) -> Area2D:
	var area = create_area_2d(coll_layer, colls_masks)
	var collision_shape = CollisionShape2D.new()
	
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = radius
	collision_shape.shape = circle_shape
	area.add_child(collision_shape)
	return area

func create_rectangular_area_2d(size: Vector2, coll_layer = 1, colls_masks = [1, 2]) -> Area2D:
	var area = create_area_2d(coll_layer, colls_masks)
	var collision_shape = CollisionShape2D.new()
	
	var line_shape = RectangleShape2D.new()
	line_shape.size = size
	collision_shape.shape = line_shape
	area.add_child(collision_shape)
	return area

# Load files into resources
func load_skill_list() -> Dictionary[String, SkillData]:
	var skill_list: Dictionary[String, SkillData] = {}
	var dir_name := "res://resources/skills/"
	var file_names := DirAccess.get_files_at(dir_name)
	for file in file_names:
		var file_name = dir_name + file.trim_suffix('.remap')
		var data : SkillData = load(file_name)
		skill_list[data.id] = data
		
	return skill_list
