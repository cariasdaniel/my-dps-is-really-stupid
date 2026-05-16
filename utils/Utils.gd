extends Node

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
